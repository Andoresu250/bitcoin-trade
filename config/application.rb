require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BitcoinWorld
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.assets.initialize_on_precompile = false
    config.time_zone = 'Bogota'
    config.active_record.default_timezone = :local
    config.i18n.available_locales = [:es, :en]
    config.i18n.default_locale = :en
    config.autoload_paths += %W["#{config.root}/app/validators/"]
    config.autoload_paths += %W("#{config.root}/lib")
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :options]
      end
    end
  end
end
