class UserMailer < ApplicationMailer
  def send_otp(user)
    @user = user
    @otp_code = user.current_otp

    mail(to: @user.email, subject: 'Your OTP Code for Two-Factor Authentication')
  end
end
