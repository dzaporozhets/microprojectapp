class ApplicationMailer < ActionMailer::Base
  from_domain = ENV['MAILGUN_DOMAIN'] || ENV['APP_DOMAIN'] || 'example.com'

  default from: "noreply@#{from_domain}"

  layout "mailer"

  def mail(*args)
    if Rails.application.config.app_settings[:disable_email_login]
      Rails.logger.info "Email delivery is disabled through DISABLE_EMAIL_LOGIN flag."

      nil
    else
      super
    end
  end
end
