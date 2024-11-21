require "rails_helper"

RSpec.describe ActivityPubDeliveryJob, type: :job do
  describe "#peform" do
    let(:activity_pub_delivery_client) { instance_double(ActivityPubDeliveryClient) }
    let(:inbox_url) { double(:inbox_url) }
    let(:json) { double(:json) }
    let(:response) { double(:response) }

    before do
      allow(ActivityPubDeliveryClient).to receive(:new).with(inbox_url, json).and_return(activity_pub_delivery_client)
      allow(activity_pub_delivery_client).to receive(:send).and_return(response)
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:body).and_return("OK")
    end

    it "shoud call ActivityPubDeliveryClient#send" do
      expect(activity_pub_delivery_client).to receive(:send)

      ActivityPubDeliveryJob.perform_now(inbox_url, json)
    end
  end
end
