class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  layout 'admin'

  def index
    @total_users = User.count
    @total_projects = Project.count
    @total_files = Project.count(:project_files)
    @total_tasks = Task.count
    @total_comments = Comment.count
    @version = '0.7.0'
    @rails_env = ENV['RAILS_ENV']
    @domain = ENV['APP_DOMAIN'] || 'Not configured'
    @allowed_domain = ENV['APP_ALLOWED_EMAIL_DOMAIN'] || 'Not configured'
    @app_signup = ENV['APP_DISABLE_SIGNUP'].present? ? 'Disabled' : 'Enabled'
    @email_confirmation = User.skip_email_confirmation? ? 'Disabled' : 'Enabled'
    @file_storage = ENV['AWS_S3_BUCKET'].present? ? 'AWS S3' : 'Local'
    @mail_delivery = Rails.application.config.action_mailer.delivery_method || 'Not configured'

    # Last 24 hours activities
    @recent_activities_count = Activity.where('created_at >= ?', 24.hours.ago).count
    @recent_users_count = User.where('created_at >= ?', 24.hours.ago).count
  end
end
