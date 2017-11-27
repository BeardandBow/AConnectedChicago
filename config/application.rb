require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_record/railtie"
require "active_model/railtie"
# require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "carrierwave"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AConnectedChicago
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_support.bare = true
    config.active_record.time_zone_aware_types = [:datetime, :time]
    config.time_zone = "Central Time (US & Canada)"
    config.active_record.default_timezone = :local
  end
end
