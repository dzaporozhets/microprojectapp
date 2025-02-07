require "active_support/core_ext/integer/time"

Rails.application.configure do
  #=========================================
  #============== GENERAL CONFIG ===========
  #=========================================

  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.force_ssl = true

  # Logger settings
  config.logger = ActiveSupport::TaggedLogging.new(
    ActiveSupport::Logger.new(STDOUT).tap { |logger| logger.formatter = ::Logger::Formatter.new }
  )
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Asset configuration
  config.assets.compile = false
  config.active_storage.service = :local

  # Internationalization
  config.i18n.fallbacks = true

  # Deprecation warnings
  config.active_support.report_deprecations = false

  # Database settings
  config.active_record.dump_schema_after_migration = false

  #=========================================
  #============== EMAIL CONFIG =============
  #=========================================

  smtp_server = ENV["SMTP_SERVER"] || ENV["MAILGUN_SMTP_SERVER"]
  smtp_login  = ENV["SMTP_LOGIN"] || ENV["MAILGUN_SMTP_LOGIN"]
  smtp_pass   = ENV["SMTP_PASSWORD"] || ENV["MAILGUN_SMTP_PASSWORD"]
  disable_email = ENV.fetch("DISABLE_EMAIL_LOGIN", "false") == "true"
  app_domain = ENV["APP_DOMAIN"]

  if disable_email
    config.action_mailer.perform_deliveries = false
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.delivery_method = :test
  elsif smtp_server.present?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: smtp_server,
      port: 587,
      domain: app_domain,
      user_name: smtp_login,
      password: smtp_pass,
      authentication: "plain",
      enable_starttls_auto: true
    }
  else
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
  end

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: app_domain } if app_domain.present?

  #=========================================
  #==== DATABASE ENCRYPTION CONFIG =========
  #=========================================

  if ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"].present?
    config.active_record.encryption.primary_key = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]
    config.active_record.encryption.deterministic_key = ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"]
    config.active_record.encryption.key_derivation_salt = ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"]
  elsif Rails.application.credentials.active_record_encryption.present?
    # Credentials will be used automatically
  else
    puts "Warning: Using randomly generated encryption keys for ActiveRecord. Configure ENV variables to secure data."
    config.active_record.encryption.primary_key = SecureRandom.hex(32)
    config.active_record.encryption.deterministic_key = SecureRandom.hex(32)
    config.active_record.encryption.key_derivation_salt = SecureRandom.hex(32)
  end
end
