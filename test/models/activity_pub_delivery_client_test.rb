require "test_helper"

class ActivityPubDeliveryClientTest < ActiveSupport::TestCase
  setup do
    Relay::Keygen.run
    WebMock.enable!
  end

  test "post activity pub delivery" do
    stub_request(:post, "http://www.example.com/inbox").
      with(
        body: "{\"@context\":\"https://www.w3.org/ns/activitystreams https://w3id.org/security/v1\",\"id\":\"http://www.example.com/actor#accepts/follows/www.example.com\",\"type\":\"Accept\",\"actor\":\"http://www.example.com/actor\"}",
        headers: {
          "Content-Type" => 'application/ld+json;profile="https://www.w3.org/ns/activitystreams"',
          "Digest" => "SHA-256=ijFumwSM5G2o89u2t9AwyGKnT5RVRtf8W88Gg1f7Cqo=",
          "Host" => "www.example.com",
          "Signature"=> /keyId=\"localhost:3000\",algorithm=\"rsa-sha256\",headers=\"\(request-target\) host date digest\",signature=\".+\"/,
          "User-Agent"=>"activity-pub-relay"
        }
      )

    body = {
      "@context" => "https://www.w3.org/ns/activitystreams https://w3id.org/security/v1",
      "id" => "http://www.example.com/actor#accepts/follows/www.example.com",
      "type" => "Accept",
      "actor" => "http://www.example.com/actor"
    }.to_json

    ActivityPubDeliveryClient.new("http://www.example.com/inbox", body).send
  end

  teardown do
    path = Rails.root.join("config/actor.pem")
    if File.exist?(path)
      FileUtils.rm_rf(path)
    end
    WebMock.disable!
  end
end
