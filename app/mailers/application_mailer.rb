class ApplicationMailer < ActionMailer::Base
  from_domain = ENV['MAILGUN_DOMAIN'] || ENV['APP_DOMAIN'] || 'example.com'

  default from: "noreply@#{from_domain}"

  layout "mailer"

  def mail(*args)
    if DISABLE_EMAIL_LOGIN
      Rails.logger.info "Email delivery is disabled through DISABLE_EMAIL_LOGIN flag."

      return
    else
      super
    end
  end
end
