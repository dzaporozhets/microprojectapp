# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :check_oauth_user, only: [:create]

  def create
    super
  end

  protected

  def find_user
    if params.dig(:user, :email)
      User.find_by(email: params[:user][:email])
    end
  end

  def check_oauth_user
    user = find_user
    if user&.oauth_user?
      flash[:alert] = "Please sign in with #{user.provider_human} instead."

      redirect_to new_user_session_path
    end
  end
end
