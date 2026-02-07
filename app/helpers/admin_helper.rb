module AdminHelper
  def admin_tabs(selected = nil)
    tabs = [
      { name: 'Application', path: admin_path },
      { name: 'Users', path: admin_users_path },
      { name: 'Activity', path: admin_activity_path }
    ]

    render_tabs(tabs, selected)
  end

  def admin_config_uploads_storage
    if Rails.application.config.app_settings[:aws_s3_bucket].present?
      if ENV['BUCKETEER_BUCKET_NAME'].present?
        'AWS S3 (via Bucketeer)'
      else
        'AWS S3'
      end
    elsif Rails.application.config.app_settings[:enable_local_file_storage].present?
      'Local'
    else
      'Disabled'
    end
  end
end
