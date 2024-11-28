require "rails_helper"

RSpec.describe "/", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("LOCAL_DOMAIN").and_return("www.example.com")
  end

  it "visit /" do
    visit "/"

    expect(page).to have_content("ActivityPub Relay")
    expect(page).to have_content("https://www.example.com/inbox")
  end
end
