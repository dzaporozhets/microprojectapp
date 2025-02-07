# frozen_string_literal: true

require 'devise/orm/active_record'

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

  from_domain = ENV['MAILGUN_DOMAIN'] || ENV['APP_DOMAIN'] || 'example.com'
  config.mailer_sender = "no-reply@#{from_domain}"

  #=========================================
  #=========== OAUTH CONFIGURATION =========
  #=========================================

  if ENV['GOOGLE_CLIENT_ID'].present?
    config.omniauth :google_oauth2,
                    ENV['GOOGLE_CLIENT_ID'],
                    ENV['GOOGLE_CLIENT_SECRET'],
                    scope: 'userinfo.email,userinfo.profile',
                    redirect_uri: ENV['GOOGLE_REDIRECT_URI']
  end

  if ENV['MICROSOFT_CLIENT_ID'].present?
    config.omniauth :entra_id,
                    client_id: ENV['MICROSOFT_CLIENT_ID'],
                    client_secret: ENV['MICROSOFT_CLIENT_SECRET'],
                    tenant_id: ENV['MICROSOFT_TENANT_ID']
  end

  # OAuth configuration for testing environment
  if Rails.env.test?
    config.omniauth :google_oauth2, '1234', 'abcd'
    config.omniauth :entra_id, client_id: '1234', client_secret: 'abcd', tenant_id: 'common'
  end

  #=========================================
  #======= DISABLE EMAIL LOGIN OPTION ======
  #=========================================

  DISABLE_EMAIL_LOGIN = %w[true 1 yes].include?(ENV.fetch('DISABLE_EMAIL_LOGIN', 'false').downcase)
end
