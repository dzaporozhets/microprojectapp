# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  # Google oauth
  def google_oauth2
    auth_info = {
      uid: auth.uid,
      provider: auth.provider,
      email: auth.info&.email,
      image: auth.info&.image
    }

    user = User.from_omniauth(auth_info)

    if user.present?
      sign_out_all_scopes
      remember_me(user)
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = "Login with Google failed"
      redirect_to new_user_session_path
    end

  rescue User::SignupsDisabledError => e
    flash[:alert] = e.message
    redirect_to new_user_session_path
  end

  def entra_id
    auth_info = {
      uid: auth.uid,
      provider: auth.provider,
      email: auth.info&.email
    }

    user = User.from_omniauth(auth_info)

    if user.present?
      sign_out_all_scopes
      remember_me(user)
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = "Login with Microsoft failed"
      redirect_to new_user_session_path
    end

  rescue User::SignupsDisabledError => e
    flash[:alert] = e.message
    redirect_to new_user_session_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
