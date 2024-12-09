require "rails_helper"

RSpec.describe "/actors", type: :request do
  describe "GET /actors" do
    let(:public_key_pem) { Actor.key.public_key.to_pem }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("LOCAL_DOMAIN", "www.example.com").and_return("www.example.com")

      get '/actor'
    end

    it "should return json" do
      expect(response.content_type).to eq 'application/activity+json; charset=utf-8'
    end

    it "should return 200" do
      expect(response.status).to eq 200
    end

    it "has actor data" do
      expected_json = {
        "@context" => [
          "https://www.w3.org/ns/activitystreams",
          "https://w3id.org/security/v1"
        ],
        "id" =>"https://www.example.com/actor",
        "type" => "Service",
        "preferredUsername" => "relay",
        "inbox" => "https://www.example.com/inbox",
        "publicKey" => {
          "id" => "https://www.example.com/actor#main-key",
          "owner"=>"https://www.example.com/actor",
          "publicKeyPem" => public_key_pem
        }
      }

      actuacl_json = JSON.parse(response.body)

      expect(expected_json).to eq actuacl_json
    end
  end
end
