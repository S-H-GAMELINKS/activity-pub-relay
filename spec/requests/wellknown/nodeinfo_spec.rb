require "rails_helper"

RSpec.describe "/.well-known/nodeinfo", type: :request do
  describe "GET /.well-known/nodeinfo" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("LOCAL_DOMAIN", "www.example.com").and_return("www.example.com")

      get "/.well-known/nodeinfo"
    end

    it "should return 200" do
      expect(response).to have_http_status 200
    end

    it "should content-type is application/json" do
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end

    it "should return nodeinfo" do
      expected_json = {
        "links" => [
          {
            "rel" => "http://nodeinfo.diaspora.software/ns/schema/2.1",
            "href" => "https://www.example.com/nodeinfo/2.1"
          }
        ]
      }

      actuacl_json = JSON.parse(response.body)

      expect(expected_json).to eq actuacl_json
    end
  end
end
