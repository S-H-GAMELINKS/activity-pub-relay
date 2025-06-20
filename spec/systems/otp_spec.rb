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

    if page.has_css?('form')
      within('form') do
        if page.has_css?('input[type="submit"]')
          find('input[type="submit"]').click
        elsif page.has_css?('button[type="submit"]')
          find('button[type="submit"]').click
        elsif page.has_css?('button')
          find('button').click
        else
          page.execute_script('document.forms[0].submit();')
        end
      end
    else
      page.execute_script('window.location.href = "/";')
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

    if page.has_css?('form')
      within('form') do
        if page.has_css?('input[type="submit"]')
          find('input[type="submit"]').click
        elsif page.has_css?('button[type="submit"]')
          find('button[type="submit"]').click
        elsif page.has_css?('button')
          find('button').click
        else
          page.execute_script('document.forms[0].submit();')
        end
      end
    else
      page.execute_script('window.location.href = "/";')
    end

    visit "/login"

    fill_in "email", with: "activity-pub-relay@example.com"
    fill_in "password", with: "activity-pub-relay-pass"
    click_on "Login"
  end
end
