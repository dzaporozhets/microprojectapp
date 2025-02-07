# frozen_string_literal: true

require 'devise/orm/active_record'

# Load cached environment settings
app_settings = Rails.application.config.app_settings

# Allow OTP drift (in seconds)
Devise.otp_allowed_drift = 600

Devise.setup do |config|
  #=========================================
  #============ GENERAL SETTINGS ===========
  #=========================================

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  config.reconfirmable = true
  config.reset_password_within = 6.hours
  config.lock_strategy = :failed_attempts
  config.unlock_strategy = :time
  config.maximum_attempts = 10
  config.unlock_in = 1.hour
  config.last_attempt_warning = true
  config.allow_unconfirmed_access_for = 1.hour
  config.paranoid = true
  config.sign_out_via = :delete

  #=========================================
  #=========== EMAIL CONFIGURATION =========
  #=========================================

  config.mailer_sender = "no-reply@#{app_settings[:email_domain]}"

  #=========================================
  #=========== OAUTH CONFIGURATION =========
  #=========================================

  if app_settings[:google_client_id]
    config.omniauth :google_oauth2,
                    app_settings[:google_client_id],
                    app_settings[:google_client_secret],
                    scope: 'userinfo.email,userinfo.profile',
                    redirect_uri: app_settings[:google_redirect_uri]
  end

  if app_settings[:microsoft_client_id]
    config.omniauth :entra_id,
                    client_id: app_settings[:microsoft_client_id],
                    client_secret: app_settings[:microsoft_client_secret],
                    tenant_id: app_settings[:microsoft_tenant_id]
  end

  # OAuth configuration for testing environment
  if Rails.env.test?
    config.omniauth :google_oauth2, '1234', 'abcd'
    config.omniauth :entra_id, client_id: '1234', client_secret: 'abcd', tenant_id: 'common'
  end
end
