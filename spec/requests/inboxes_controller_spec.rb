require "rails_helper"

RSpec.describe "/inbox", type: :request do
  describe "POST /inbox" do
    before do
      post "/inbox"
    end

    it "should return 202", :skip do
      expect(response.status). to eq 202
    end
  end
end
