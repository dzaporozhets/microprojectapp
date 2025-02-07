class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  layout 'admin'

  def index
    app_settings = Rails.application.config.app_settings

    @total_users = User.count
    @total_projects = Project.count
    @total_files = Project.count(:project_files)
    @total_tasks = Task.count
    @total_comments = Comment.count
    @version = '0.9.0'
    @rails_env = Rails.env
    @domain = app_settings[:app_domain]
    @allowed_domain = app_settings[:app_allowed_email_domain] || 'Not configured'
    @app_signup = app_settings[:disable_signup] ? 'Disabled' : 'Enabled'
    @file_storage = app_settings[:aws_s3_bucket].present? ? 'AWS S3' : 'Local'
    @mail_delivery = Rails.application.config.action_mailer.delivery_method || 'Not configured'
    @disable_email_login = app_settings[:disable_email_login]
    @oauth_providers = Devise.omniauth_providers

    # Last 24 hours activities
    @recent_activities_count = Activity.where('created_at >= ?', 24.hours.ago).count
    @recent_users_count = User.where('created_at >= ?', 24.hours.ago).count
  end
end
