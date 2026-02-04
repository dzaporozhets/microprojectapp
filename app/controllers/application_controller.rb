class ApplicationController < ActionController::Base
  before_action :touch_flash

  # Run authentication before any action except for Devise controllers
  before_action :authenticate_user!, unless: :devise_controller?

  before_action :set_paper_trail_whodunnit

  helper_method :turbo_frame_request?

  def record_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
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

  def project_owner_only!
    unless current_user == project.owner
      raise ActiveRecord::RecordNotFound
    end
  end

  def require_file_storage!
    unless file_storage_enabled?
      redirect_back(fallback_location: root_path, alert: 'File uploads are not enabled.')
    end
  end

  def file_storage_enabled?
    app_settings = Rails.application.config.app_settings
    app_settings[:aws_s3_bucket].present? || app_settings[:enable_local_file_storage]
  end
  helper_method :file_storage_enabled?
end
