require "active_support/core_ext/integer/time"

Rails.application.configure do
  #=========================================
  #============== GENERAL CONFIG ===========
  #=========================================

  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assume_ssl = true
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

  config.action_mailer.perform_deliveries = false
end
