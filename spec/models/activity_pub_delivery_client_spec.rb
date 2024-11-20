require "rails_helper"

RSpec.describe ActivityPubDeliveryClient, type: :model do
  describe "#send" do
    let(:url) { URI.parse("https://www.example.com/inbox") }
    let(:signature) { "JS4lefDknSlVt6WbsFU7geOyXgC2PmGcZSaHpYeKQ8+aV34k49Ka9HUL+oXlYxbtESPl+gPHcvNYx5TX1oS0kK3x5cFjRmIm03W4U2Z7eQpj+cNX1vpnSyhl4DHnN3tNbICemUwt2NRv0UlwBw+DXLLd32e9BLpwtvA/KSt9DYG0Pfcr52hv1IfELFYwCdt9KlxsK/GhL02/LGGGoeFkF/8Uo+HLalvM3xQlLDeBZXuxi/egtFfUmlXKLrVlIqxTkcQDL8WfGuAQFljINkj4Qvv5XwUTsGJs2vabhL41Qlr21sZwGtrDI++lFChHd4uj07/grSAeK9XItMV9YRqTIA=="  }
    let(:expected_body) { "{\"@context\":\"https://www.w3.org/ns/activitystreams https://w3id.org/security/v1\",\"id\":\"https://www.example.com/actor#accepts/follows/www.example.com\",\"type\":\"Accept\",\"actor\":\"https://www.example.com/actor\"}" }
    let(:options) {
      {
        'Host': "www.example.com",
        'Date': Time.now.utc.httpdate,
        'Digest': "SHA-256=UEf3Gb+7KoVuTocInGSJWg3IbPqbinwd7EYfbFFiZKQ=",
        'Signature': "keyId=\"https://www.example.com/actor\",algorithm=\"rsa-sha256\",headers=\"(request-target) host date digest\",signature=\"#{signature}\"",
        'User-Agent': "activity-pub-relay",
        'Content-Type': "application/ld+json;profile=\"https://www.w3.org/ns/activitystreams\""
      }
    }

    before do
      freeze_time
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("LOCAL_DOMAIN", "www.example.com").and_return("www.example.com")
      allow_any_instance_of(ActivityPubDeliveryClient).to receive(:signature).and_return(signature)
    end

    it "should send activity pub delivery" do
      expect(Net::HTTP).to receive(:post).with(url, expected_body, options)

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
