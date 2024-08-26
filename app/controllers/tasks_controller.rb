class TasksController < ApplicationController
  def index
    @tasks = tasks.page(params[:page]).per(100)
  end

  private

  def tasks
    Task.where(project_id: current_user.all_active_projects).todo
  end
end
