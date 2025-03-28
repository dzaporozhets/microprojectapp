# frozen_string_literal: true

class Users::SettingsController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def show
    @user = current_user
  end

  def update
    if current_user.update(settings_params)
      redirect_to users_settings_path, notice: 'Saved'
    else
      redirect_to users_settings_path, notice: 'An error occurred'
    end
  end

  def regenerate_calendar_token
    if current_user.regenerate_calendar_token!
      redirect_to users_settings_path, notice: 'Calendar token has been regenerated'
    else
      redirect_to users_settings_path, alert: 'Failed to regenerate calendar token'
    end
  end

  private

  def settings_params
    params.require(:user).permit(:allow_invites, :dark_mode, :otp_required_for_login, :avatar, :theme)
  end
end
