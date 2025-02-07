require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Load cached environment settings
  app_settings = Rails.application.config.app_settings

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

  if app_settings[:disable_email_login]
    config.action_mailer.perform_deliveries = false
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.delivery_method = :test
  elsif app_settings[:smtp_server].present?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: app_settings[:smtp_server],
      port: 587,
      domain: app_settings[:app_domain],
      user_name: app_settings[:smtp_login],
      password: app_settings[:smtp_password],
      authentication: "plain",
      enable_starttls_auto: true
    }
  else
    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
  end

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: app_settings[:app_domain] } if app_settings[:app_domain].present?

  #=========================================
  #==== DATABASE ENCRYPTION CONFIG =========
  #=========================================

  if app_settings[:active_record_encryption_primary_key]
    config.active_record.encryption.primary_key = app_settings[:active_record_encryption_primary_key]
    config.active_record.encryption.deterministic_key = app_settings[:active_record_encryption_deterministic_key]
    config.active_record.encryption.key_derivation_salt = app_settings[:active_record_encryption_key_derivation_salt]
  elsif Rails.application.credentials.active_record_encryption.present?
    # Credentials will be used automatically
  else
    puts "Warning: Using randomly generated encryption keys for ActiveRecord. Configure ENV variables to secure data."
    config.active_record.encryption.primary_key = SecureRandom.hex(32)
    config.active_record.encryption.deterministic_key = SecureRandom.hex(32)
    config.active_record.encryption.key_derivation_salt = SecureRandom.hex(32)
  end
end
