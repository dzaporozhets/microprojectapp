class TasksController < ApplicationController
  before_action :task, only: :toggle_done

  def index
    @tasks = tasks
    @tasks = @tasks.where(assigned_user_id: current_user.id) if params[:assigned] == 'true'
    @tasks = @tasks.page(params[:page]).per(100)
  end

  def toggle_done
    respond_to do |format|
      if @task.update(params.require(:task).permit(:done))
        @task.project.add_activity(current_user, (@task.done ? 'closed' : 'opened'), @task)

        format.turbo_stream { render turbo_stream: turbo_stream.remove("task_#{@task.id}") }
        format.html { redirect_back fallback_location: tasks_path, notice: "Task status was successfully updated." }
      else
        format.html { redirect_back fallback_location: tasks_path, alert: 'Failed to update task status.' }
      end
    end
  end

  private

  def task
    @task ||= tasks.find(params[:id])
  end

  def tasks
    Task.where(project_id: current_user.all_active_projects).todo.order(id: :desc)
  end

end
