require "rails_helper"

RSpec.describe PleromaFollowHandler, type: :model do
  describe "#call" do
    let(:actor) { double(:actor) }
    let(:json) { double(:json) }
    let(:activity_pub_delivery_client) { instance_double(ActivityPubDeliveryClient) }

    before do
      allow(actor).to receive(:[]).with("inbox").and_return("https://www.example.com/inbox")
      allow(actor).to receive(:[]).with("id").and_return("https://www.example.com/relay")
      allow(json).to receive(:[]).with("id").and_return("https://www.example.com/actor#accepts/follows/www.example.com")
      allow(ActivityPubDeliveryClient).to receive(:new).and_return(activity_pub_delivery_client)
    end

    context "when send accept activity response is not 200" do
      let(:response) { double(:response) }
      let(:code) { "500" }
      let(:body) { "Internal Server Error" }

      before do
        allow(activity_pub_delivery_client).to receive(:send).and_return(response)
        allow(response).to receive(:code).and_return(code)
        allow(response).to receive(:body).and_return(body)
      end

      it "should return nil" do
        result = PleromaFollowHandler.new(actor, json).call

        expect(result).to be_nil
      end

      it "should not create SubscribeServer" do
        expect {
          PleromaFollowHandler.new(actor, json).call
        }.not_to change { SubscribeServer.count }
      end

      it "should not loged" do
        expect(Rails.logger).not_to receive(:info)

        PleromaFollowHandler.new(actor, json).call
      end
    end

    context "when send accept activity response is 200" do
      context "when send follow activity response is not 200" do
        let(:response) { Data.define(:code, :body) }

        before do
          count = 1

          allow(activity_pub_delivery_client).to receive(:send).twice do
            if count == 1
              count += 1
              response.new(code: "200", body: "OK")
            else
              response.new(code: "500", body: "Internal Server Error")
            end
          end
        end

        it "should not create SubscribeServer" do
        end

        it "should loged twice" do
          expect(Rails.logger).to receive(:info).twice

          PleromaFollowHandler.new(actor, json).call
        end
      end

      context "when send follow activity response is 200" do
        let(:response) { double(:response) }
        let(:code) { "200" }
        let(:body) { "OK" }

        before do
          allow(activity_pub_delivery_client).to receive(:send).and_return(response)
          allow(response).to receive(:code).and_return(code)
          allow(response).to receive(:body).and_return(body)
        end

        it "should create SubscribeServer" do
          expect {
            PleromaFollowHandler.new(actor, json).call
          }.to change { SubscribeServer.count }.by(1)
        end

        it "should loged twice" do
          expect(Rails.logger).to receive(:info).twice

          PleromaFollowHandler.new(actor, json).call
        end
      end
    end
  end
end
