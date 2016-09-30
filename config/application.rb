require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SemanaDeTecnologia
  class Application < Rails::Application



    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.app_generators.stylesheet_engine :less

    config.serve_static_files = true

    config.generators do |g|
      g.templates.unshift File::expand_path('../../templates', __FILE__)
    end

    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end

    ActionMailer::Base.smtp_settings = {
      :user_name => Rails.application.secrets.sendgrid_user,
      :password => Rails.application.secrets.sendgrid_password,
      :domain => Rails.application.secrets.site_domain,
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end
end
