source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'activeadmin'
gem 'rails', '~> 5.2.3'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap', '~> 4.0.0'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'libv8', '~> 3.16.14.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rollbar'
gem 'pg', '0.19.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'simple_form'
gem 'jquery-ui-rails'
gem 'httparty'
gem 'delayed_job', '4.1.8'
gem 'delayed_job_recurring', '0.3.8'
gem 'premailer-rails'
gem 'paper_trail'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
gem 'timezone', '1.2.8'
gem 'bootstrap4-datetime-picker-rails'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.7'
  gem 'rails-controller-testing'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', "~> 4.10.0"
  gem 'awesome_print'
  gem 'dotenv-rails'
end

group :development do
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
end

group :test do
  gem 'simplecov', require: false
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'capybara-screenshot'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
