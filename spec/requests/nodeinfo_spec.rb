require "rails_helper"

RSpec.describe "/nodeinfo", type: :request do
  describe "GET /nodeinfo/2.1" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("LOCAL_DOMAIN", "www.example.com").and_return("www.example.com")

      get "/nodeinfo/2.1"
    end

    it "should return 200" do
      expect(response).to have_http_status 200
    end

    it "should return json" do
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end

    it "should return nodeinfo" do
      expected_json = {
        "openRegistrations" => true,
        "protocols" => [
          "activitypub"
        ],
        "services" => {
          "inbound" => [],
          "outbound" => []
        },
        "software" => {
          "name" => "activity-pub-relay",
          "version" => "0.8.0",
          "repository" => "https://github.com/S-H-GAMELINKS/activity-pub-relay"
        },
        "usage" => {
          "localPosts" => 0,
          "users" => {
            "total" => 1
          }
        },
        "version" => "2.1",
        "metadata" => {}
      }

      actual_json = JSON.parse(response.body)

      expect(expected_json).to eq actual_json
    end
  end
end
