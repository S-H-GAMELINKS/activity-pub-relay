Capybara.register_driver :selenium_chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
