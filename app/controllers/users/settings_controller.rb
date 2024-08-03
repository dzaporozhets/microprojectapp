# frozen_string_literal: true

class Users::SettingsController < ApplicationController
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

  private

  def settings_params
    params.require(:user).permit(:allow_invites, :disable_password)
  end
end

