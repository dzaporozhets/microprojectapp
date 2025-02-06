# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :check_signup_disabled, only: [:new, :create]
  before_action :check_oauth_user, only: [:edit, :update]

  layout 'user', only: [:edit, :update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    # Don't allow email and password change if user log in with google
    if resource.oauth_user?
      params[:user].delete(:email)
    end

    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:allow_invites])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # Where to redirect users once they have registered
  def after_sign_up_path_for(resource)
    if defined?(hello_path)
      hello_path
    else
      super
    end
  end

  def after_update_path_for(resource)
    if resource
      edit_registration_path(resource)
    else
      root_path
    end
  end

  def check_signup_disabled
    if User.disabled_signup?
      flash[:alert] = "New registrations are currently disabled."

      redirect_to new_user_session_path
    end
  end

  def check_oauth_user
    if current_user && current_user.oauth_user?
      flash[:alert] = "Not allowed for OAuth user."

      redirect_to users_account_path
    end
  end
end
