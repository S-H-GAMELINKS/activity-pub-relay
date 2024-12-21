require "rails_helper"

RSpec.describe MastodonFollowHandler, type: :model do
  describe "#call" do
    context "when actor['endpoints'] is hash" do
      context "when actor['endpoints']['sharedInbox'] is present" do
        let(:actor) { double(:actor) }
        let(:json) { double(:json) }
        let(:endpoints_hash) {
          {
            "sharedInbox" => "https://www.example.com/inbox"
          }
        }
        let(:activity_pub_delivery_client) { instance_double(ActivityPubDeliveryClient) }
        let(:response) { double(:response) }

        before do
          allow(actor).to receive(:[]).with("endpoints").and_return(endpoints_hash)
          allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
          allow(json).to receive(:[]).with("id").and_return("https://www.example.com/actor#accepts/follows/www.example.com")
          allow(ActivityPubDeliveryClient).to receive(:new).and_return(activity_pub_delivery_client)
          allow(activity_pub_delivery_client).to receive(:send).and_return(response)
          allow(response).to receive(:code).and_return("202")
          allow(response).to receive(:body).and_return("OK")
        end

        it "should call ActivityPubDeliveryClient#send" do
          expect(activity_pub_delivery_client).to receive(:send)

          MastodonFollowHandler.new(actor, json).call
        end

        it "should create SubscribeServer" do
          expect {
            MastodonFollowHandler.new(actor, json).call
          }.to change { SubscribeServer.count }.from(0).to(1)
        end

        it "should loged" do
          expect(Rails.logger).to receive(:info)

          MastodonFollowHandler.new(actor, json).call
        end
      end

      context "when actor['endpoints']['shared'] is blank" do
        let(:actor) { double(:actor) }
        let(:json) { double(:json) }
        let(:endpoints_hash) {
          {
            "sharedInbox" => nil
          }
        }
        let(:activity_pub_delivery_client) { instance_double(ActivityPubDeliveryClient) }
        let(:response) { double(:response) }

        before do
          allow(actor).to receive(:[]).with("endpoints").and_return(endpoints_hash)
          allow(actor).to receive(:[]).with("inbox").and_return("https://www.example.com/inbox")
          allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
          allow(json).to receive(:[]).with("id").and_return("https://www.example.com/actor#accepts/follows/www.example.com")
          allow(ActivityPubDeliveryClient).to receive(:new).and_return(activity_pub_delivery_client)
          allow(activity_pub_delivery_client).to receive(:send).and_return(response)
          allow(response).to receive(:code).and_return("202")
          allow(response).to receive(:body).and_return("OK")
        end

        it "should call ActivityPubDeliveryClient#send" do
          expect(activity_pub_delivery_client).to receive(:send)

          MastodonFollowHandler.new(actor, json).call
        end

        it "should create SubscribeServer" do
          expect {
            MastodonFollowHandler.new(actor, json).call
          }.to change { SubscribeServer.count }.from(0).to(1)
        end

        it "should loged" do
          expect(Rails.logger).to receive(:info)

          MastodonFollowHandler.new(actor, json).call
        end
      end
    end

    context "when actor['endpoints'] is not hash" do
      let(:actor) { double(:actor) }
      let(:json) { double(:json) }
      let(:activity_pub_delivery_client) { instance_double(ActivityPubDeliveryClient) }
      let(:response) { double(:response) }

      before do
        allow(actor).to receive(:[]).with("endpoints").and_return(nil)
        allow(actor).to receive(:[]).with("inbox").and_return("https://www.example.com/inbox")
        allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
        allow(json).to receive(:[]).with("id").and_return("https://www.example.com/actor#accepts/follows/www.example.com")
        allow(ActivityPubDeliveryClient).to receive(:new).and_return(activity_pub_delivery_client)
        allow(activity_pub_delivery_client).to receive(:send).and_return(response)
        allow(response).to receive(:code).and_return("202")
        allow(response).to receive(:body).and_return("OK")
      end

      it "should call ActivityPubDeliveryClient#send" do
        expect(activity_pub_delivery_client).to receive(:send)

        MastodonFollowHandler.new(actor, json).call
      end

      it "should create SubscribeServer" do
        expect {
          MastodonFollowHandler.new(actor, json).call
        }.to change { SubscribeServer.count }.from(0).to(1)
      end

      it "should loged" do
        expect(Rails.logger).to receive(:info)

        MastodonFollowHandler.new(actor, json).call
      end
    end

    context "when raise ActiveRecord::RecordInvalid" do
      let(:actor) { double(:actor) }
      let(:json) { double(:json) }
      let(:activity_pub_delivery_client) { instance_double(ActivityPubDeliveryClient) }
      let(:response) { double(:response) }

      before do
        allow(actor).to receive(:[]).with("endpoints").and_return(nil)
        allow(actor).to receive(:[]).with("inbox").and_return("")
        allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
        allow(json).to receive(:[]).with("id").and_return("https://www.example.com/actor#accepts/follows/www.example.com")
        allow(ActivityPubDeliveryClient).to receive(:new).and_return(activity_pub_delivery_client)
        allow(activity_pub_delivery_client).to receive(:send).and_return(response)
        allow(response).to receive(:code).and_return("202")
        allow(response).to receive(:body).and_return("OK")
      end

      before do
        create(:subscribe_server, domain: "www.example.com", inbox_url: "https://www.example.com/inbox")
      end

      it "shoud output error log" do
        expect(Rails.logger).to receive(:error)

        MastodonFollowHandler.new(actor, json).call
      end
    end
  end
end
