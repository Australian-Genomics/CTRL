require 'cucumber/rails'
require 'database_cleaner'
require 'selenium-webdriver'
require 'capybara-screenshot/cucumber'

ENV['REDCAP_CONNECTION_ENABLED'] = 'false'

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: 'http://selenium:4444/',
    options: options
  )
end

Capybara.default_driver = :selenium

Capybara.app_host = 'http://web:3000'

ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = DatabaseCleaner::NullStrategy
DatabaseCleaner.clean

Cucumber::Rails::Database.javascript_strategy = :truncation
