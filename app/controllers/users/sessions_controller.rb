# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :check_oauth_user, only: [:create]

  prepend_before_action :auth_with_two_factor, only: [:create], if: -> { two_factor_enabled? }

  # def new
  #   super
  # end

  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  def two_factor_enabled?
    find_user.try(:two_factor_enabled?)
  end

  def auth_with_two_factor
    user = find_user
    return unless user

    self.resource = user

    # If second step (after otp input)
    if user_params[:otp_attempt].present? && session[:otp_user_id]
      auth_user_with_otp(resource)

    # If first step (after login and password)
    elsif resource.valid_password?(user_params[:password])
      session[:otp_user_id] = resource.id
      send_two_factor_authentication_code(resource)

      render 'devise/sessions/two_factor'
    end
  end

  def find_user
    if session[:otp_user_id]
      User.find(session[:otp_user_id])

    elsif params.dig(:user, :email)
      User.find_by(email: params[:user][:email])
    end
  end

  def send_two_factor_authentication_code(user)
    UserMailer.send_otp(user).deliver_now
  end

  def user_params
    params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)
  end

  def auth_user_with_otp(user)
    if valid_otp_attempt?(user)
      session.delete(:otp_user_id)

      remember_me(user) if user_params[:remember_me] == '1'

      user.save!

      sign_in(user, event: :authentication)
    else
      flash.now[:alert] = 'Invalid two-factor code.'

      render 'devise/sessions/two_factor'
    end
  end

  def valid_otp_attempt?(user)
    user.validate_and_consume_otp!(user_params[:otp_attempt])
  end

  def check_oauth_user
    user = find_user
    if user&.oauth_user?
      flash[:alert] = "Please sign in with #{user.provider_human} instead."

      redirect_to new_user_session_path
    end
  end
end
