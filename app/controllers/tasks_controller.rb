class TasksController < ApplicationController
  before_action :task, only: :toggle_done

  def index
    base = tasks
    base = base.where(assigned_user_id: current_user.id) if params[:assigned] == 'true'

    today = Date.current

    # Section 1: Due dates (not paginated, typically small)
    @tasks_due = base.with_due_date.where(due_date: ..(today + 1.month)).order(due_date: :asc)

    # Section 2: Starred (no due date)
    @starred_tasks = base.no_due_date.where(star: true).order(id: :desc)

    # Section 3: All tasks, grouped by project (exclude tasks already shown above)
    @tasks = base.where.not(id: @tasks_due).where.not(id: @starred_tasks).order(id: :desc).page(params[:page]).per(100)
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
    Task.where(project_id: current_user.all_active_projects)
        .includes(:project, :assigned_user, :comments)
        .todo
  end

end
