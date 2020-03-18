require 'cucumber/rails'
require 'database_cleaner'
require 'selenium-webdriver'
require 'capybara-screenshot/cucumber'

ENV['REDCAP_CONNECTION_ENABLED'] = 'false'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.default_driver = :selenium

ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

Cucumber::Rails::Database.javascript_strategy = :truncation
