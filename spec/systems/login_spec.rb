require "rails_helper"

RSpec.describe "/login", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass", status: :verified)
  end

  it "login to dashboard" do
    visit "/login"

    fill_in "email", with: "activity-pub-relay@example.com"
    fill_in "password", with: "activity-pub-relay-pass"
    click_on "Login"

    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Subscribe Servers")
    expect(page).to have_content("Job Dashboard")
    expect(page).to have_content("OTP settings")
  end
end
