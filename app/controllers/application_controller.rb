class ApplicationController < ActionController::Base
  before_action :touch_flash

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
end
