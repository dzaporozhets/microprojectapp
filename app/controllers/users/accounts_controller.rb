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
