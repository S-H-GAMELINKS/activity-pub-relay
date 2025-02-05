require "rails_helper"

RSpec.describe "/inbox", type: :request do
  describe "POST /inbox" do
    context "account is no present" do
      before do
        account = double(:account)
        allow(account).to receive(:[]).with("id").and_return("https://www.example.com/S_H_")
        allow_any_instance_of(SignatureVerificater).to receive(:call).and_return(account)
        allow(account).to receive(:present?).and_return(false)
      end

      it "should return 401" do
        post "/inbox"

        expect(response.status).to eq 401
      end
    end

    context "account is present" do
      let(:account) { "account" }
      let(:body) { "body" }

      before do
        allow(account).to receive(:[]).with("id").and_return("https://www.example.com/S_H_")
        allow(Oj).to receive(:load).and_return(body)
        allow_any_instance_of(SignatureVerificater).to receive(:call).and_return(account)
        allow(account).to receive(:present?).and_return(true)
      end

      it "should return 202" do
        post "/inbox"

        expect(response.status).to eq 202
      end

      it "should enqueued InboxProcessJob" do
        expect(InboxProcessJob).to receive(:perform_later)

        post "/inbox"
      end
    end

    context "when domain is blocked" do
      let(:account) { "account" }
      let(:body) { "body" }

      before do
        create(:subscribe_server, domain: "www.example.com", domain_block: true)
        allow(account).to receive(:[]).with("id").and_return("https://www.example.com/S_H_")
        allow(Oj).to receive(:load).and_return(body)
        allow_any_instance_of(SignatureVerificater).to receive(:call).and_return(account)
        allow(account).to receive(:present?).and_return(true)
      end

      it "should return 401" do
        post "/inbox"

        expect(response.status).to eq 401
      end

      it "should not enqueued InboxProcessJob" do
        expect(InboxProcessJob).not_to receive(:perform_later)

        post "/inbox"
      end
    end
  end
end
