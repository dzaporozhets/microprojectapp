class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @total_users = User.count
    @total_projects = Project.count
    @total_files = Project.count(:project_files)
    @total_tasks = Task.count
    @version = '0.1'
    @rails_env = ENV['RAILS_ENV']
    @domain = ENV['APP_DOMAIN'] || 'Not configured'
    @file_storage = ENV['AWS_S3_BUCKET'].present? ? 'AWS S3' : 'Local'
    @mail_delivery = Rails.application.config.action_mailer.delivery_method || 'Not configured'
  end

  private

  def admin_only
    raise ActiveRecord::RecordNotFound unless current_user.admin?
  end
end
