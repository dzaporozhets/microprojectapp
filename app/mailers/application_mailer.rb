class ApplicationMailer < ActionMailer::Base
  from_domain = ENV['MAILGUN_DOMAIN'] || ENV['APP_DOMAIN'] || 'example.com'

  default from: "noreply@#{from_domain}"

  layout "mailer"
end
