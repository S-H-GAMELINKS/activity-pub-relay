require "rails_helper"

RSpec.describe "otp", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    create(:account, email: "activity-pub-relay@example.com", password: "activity-pub-relay-pass", status: :verified)
  end

  it "OTP" do
    visit "/login"

    fill_in "email", with: "activity-pub-relay@example.com"
    fill_in "password", with: "activity-pub-relay-pass"
    click_on "Login"

    expect(page).to have_content("OTP settings")

    click_on "OTP settings"

    otp_secret = find('#otp-key', visible: false).value
    totp = ROTP::TOTP.new(otp_secret)

    fill_in "password", with: "activity-pub-relay-pass"
    fill_in "otp", with: totp.now
    click_on "Setup TOTP Authentication"

    visit "/logout"

    expect(page).to have_css('form', wait: 5)

    within('form') do
      submit_button = find('input[type="submit"], button[type="submit"], button', match: :first)
      submit_button.click
    end

    visit "/login"

    fill_in "email", with: "activity-pub-relay@example.com"
    fill_in "password", with: "activity-pub-relay-pass"
    click_on "Login"

    expect(current_path).to eq "/otp-auth"

    visit "/dashboard"
    expect(current_path).to eq "/otp-auth"

    visit "/jobs"
    expect(current_path).to eq "/otp-auth"

    visit "/otp-disable"
    expect(current_path).to eq "/otp-auth"

    visit "/dashboard/subscribe_servers"
    expect(current_path).to eq "/otp-auth"

    sleep(31)

    freeze_time do
      fill_in "otp", with: totp.now
    end

    click_on "Authenticate Using TOTP"

    expect(current_path).to eq "/"

    visit "/dashboard"

    expect(page).to have_content("OTP settings")

    visit "/jobs"

    expect(page).to have_content("Queue")

    visit "/dashboard"

    click_on "OTP settings"

    fill_in "password", with: "activity-pub-relay-pass"
    click_on "Disable TOTP Authentication"

    visit "/logout"

    expect(page).to have_css('form', wait: 5)

    within('form') do
      submit_button = find('input[type="submit"], button[type="submit"], button', match: :first)
      submit_button.click
    end

    visit "/login"

    fill_in "email", with: "activity-pub-relay@example.com"
    fill_in "password", with: "activity-pub-relay-pass"
    click_on "Login"
  end
end
