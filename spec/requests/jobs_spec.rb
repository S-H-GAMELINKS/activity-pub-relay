require "rails_helper"

RSpec.describe "/jobs", type: :request do
  context "when user is not authenticated" do
    it "should return 302" do
      get "/jobs"

      expect(response.status).to eq 302
      expect(response).to redirect_to "/login"
    end
  end

  context "when user is authenticated" do
    before do
      create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass")
      login("activity-pub-relay@example.com", "activity-pub-relay-pass")
    end

    it "should return 200" do
      get "/jobs"

      expect(response.status).to eq 200
    end
  end
end
