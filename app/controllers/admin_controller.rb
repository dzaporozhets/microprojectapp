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
  end

  private

  def admin_only
    raise ActiveRecord::RecordNotFound unless current_user.admin?
  end
end
