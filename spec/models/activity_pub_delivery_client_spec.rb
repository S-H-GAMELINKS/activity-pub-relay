require "rails_helper"

RSpec.describe ActivityPubDeliveryClient, type: :model do
  describe "#send" do
    before do
      allow_any_instance_of(ActivityPubDeliveryClient).to receive(:digest).and_return("SHA-256=ijFumwSM5G2o89u2t9AwyGKnT5RVRtf8W88Gg1f7Cqo=")
    end

    it "should send activity pub delivery" do
      stub_request(:post, "https://www.example.com/inbox").
        with(
          body: "{\"@context\":\"https://www.w3.org/ns/activitystreams https://w3id.org/security/v1\",\"id\":\"https://www.example.com/actor#accepts/follows/www.example.com\",\"type\":\"Accept\",\"actor\":\"https://www.example.com/actor\"}",
          headers: {
            "Content-Type" => 'application/ld+json;profile="https://www.w3.org/ns/activitystreams"',
            "Digest" => "SHA-256=ijFumwSM5G2o89u2t9AwyGKnT5RVRtf8W88Gg1f7Cqo=",
            "Host" => "www.example.com",
            "Signature"=> /keyId=\"https:\/\/www.example.com\/actor\",algorithm=\"rsa-sha256\",headers=\"\(request-target\) host date digest\",signature=\".+\"/,
            "User-Agent"=>"activity-pub-relay"
          }
        )

      body = {
        "@context" => "https://www.w3.org/ns/activitystreams https://w3id.org/security/v1",
        "id" => "https://www.example.com/actor#accepts/follows/www.example.com",
        "type" => "Accept",
        "actor" => "https://www.example.com/actor"
      }.to_json

      ActivityPubDeliveryClient.new("https://www.example.com/inbox", body).send
    end
  end
end
