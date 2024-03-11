require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Agha
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.exceptions_app = self.routes
    config.generators.system_tests = nil
    config.time_zone = 'Australia/Melbourne'
    config.active_record.legacy_connection_handling = false
    if !ENV['ALLOWED_HOSTS'].empty? then config.hosts << ENV['ALLOWED_HOSTS'] end
  end
end
