require "rails_helper"

RSpec.describe "/", type: :request do
  it "should return 200" do
    get "/"

    expect(response.status).to eq 200
  end
end
