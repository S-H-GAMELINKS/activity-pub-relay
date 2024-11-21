require "rails_helper"

RSpec.describe "/dashboard", type: :request do
  context "when user is not authenticated" do
    it "should return 404" do
      get "/dashboard"

      expect(response.status).to eq 404
    end
  end

  context "when user is authenticated" do
    before do
      allow_any_instance_of(Authentication).to receive(:require_authentication).and_return(true)
    end

    it "should return 200" do
      get "/dashboard"

      expect(response.status).to eq 200
    end
  end
end
