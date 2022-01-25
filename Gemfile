source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'activeadmin'
gem 'benchmark'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.0.0'
gem 'bootstrap4-datetime-picker-rails'
gem 'delayed_job', '4.1.8'
gem 'delayed_job_recurring', '0.3.8'
gem 'devise'
gem 'httparty'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'libv8', '~> 3.16.14.0'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'paper_trail'
gem 'pg', '0.19.0'
gem 'premailer-rails'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'timezone', '1.2.8'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

gem 'foreman'
gem 'webpacker'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'pry'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.7'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails-erd'
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-screenshot'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
