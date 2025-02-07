# frozen_string_literal: true

Rails.application.config.app_settings = {
  # AWS S3 Config
  aws_s3_bucket: ENV['AWS_S3_BUCKET'].presence,
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'].presence,
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'].presence,
  aws_region: ENV['AWS_REGION'].presence,

  # SMTP (Email) Config
  smtp_server: ENV['SMTP_SERVER'].presence || ENV['MAILGUN_SMTP_SERVER'].presence,
  smtp_login: ENV['SMTP_LOGIN'].presence || ENV['MAILGUN_SMTP_LOGIN'].presence,
  smtp_password: ENV['SMTP_PASSWORD'].presence || ENV['MAILGUN_SMTP_PASSWORD'].presence,

  # App Domain & Email Config
  app_domain: ENV['APP_DOMAIN'].presence,
  app_allowed_email_domain: ENV['APP_ALLOWED_EMAIL_DOMAIN'].to_s.presence,
  mailgun_domain: ENV['MAILGUN_DOMAIN'].presence,
  email_domain: ENV['MAILGUN_DOMAIN'].presence || ENV['APP_DOMAIN'].presence || 'example.com',

  # Google OAuth
  google_client_id: ENV['GOOGLE_CLIENT_ID'].presence,
  google_client_secret: ENV['GOOGLE_CLIENT_SECRET'].presence,
  google_redirect_uri: ENV['GOOGLE_REDIRECT_URI'].presence,

  # Microsoft OAuth
  microsoft_client_id: ENV['MICROSOFT_CLIENT_ID'].presence,
  microsoft_client_secret: ENV['MICROSOFT_CLIENT_SECRET'].presence,
  microsoft_tenant_id: ENV['MICROSOFT_TENANT_ID'].presence,

  # ActiveRecord Encryption Keys
  active_record_encryption_primary_key: ENV['ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY'].presence,
  active_record_encryption_deterministic_key: ENV['ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY'].presence,
  active_record_encryption_key_derivation_salt: ENV['ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT'].presence,

  # Feature Flags
  disable_email_login: %w[true 1 yes].include?(ENV.fetch('DISABLE_EMAIL_LOGIN', 'false').downcase),
  disable_signup: %w[true 1 yes].include?(ENV.fetch('APP_DISABLE_SIGNUP', 'false').downcase)
}
