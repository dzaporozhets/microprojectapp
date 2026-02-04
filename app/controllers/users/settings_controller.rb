# frozen_string_literal: true

class Users::SettingsController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def show
    @tab_name = 'Settings'
    @user = current_user
  end

  def update
    if current_user.update(settings_params)
      redirect_to users_settings_path, notice: 'Saved'
    else
      redirect_to users_settings_path, notice: 'An error occurred'
    end
  end

  private

  def settings_params
    permitted = params.require(:user).permit(:allow_invites, :dark_mode, :avatar, :theme)
    permitted.delete(:avatar) unless file_storage_enabled?
    permitted
  end
end
