# frozen_string_literal: true

class Users::AccountsController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def show
    @tab_name = 'Account'
    @user = current_user
  end

  def update
    if current_user.update(settings_params)
      redirect_to users_settings_path, notice: 'Saved'
    else
      redirect_to users_settings_path, notice: 'An error occurred'
    end
  end

  def generate_api_token
    raw_token = current_user.generate_api_token!
    flash[:api_token] = raw_token
    redirect_to users_account_path, notice: 'API token generated. Copy it now — it won\'t be shown in full again.'
  end

  def revoke_api_token
    current_user.clear_api_token!
    redirect_to users_account_path, notice: 'API token revoked.'
  end

  def destroy
    if current_user.destroy
      sign_out current_user

      redirect_to root_path, notice: 'Your account has been successfully deleted.'
    else
      redirect_to users_account_path, alert: 'An error occurred while deleting your account.'
    end
  end

  private

  def settings_params
    params.require(:user).permit(:email)
  end
end
