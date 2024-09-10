class ApplicationController < ActionController::Base
  before_action :touch_flash

  # Run authentication before any action except for Devise controllers
  before_action :authenticate_user!, unless: :devise_controller?

  helper_method :turbo_frame_request?

  def record_not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end

  private

  def authorize_access
    if current_user.has_access_to?(project)
      true
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def authenticate_admin!
    unless current_user&.admin?
      raise ActiveRecord::RecordNotFound
    end
  end

  def touch_flash
    flash
  end

  def turbo_frame_request?
    request.headers["Turbo-Frame"].present?
  end
end
