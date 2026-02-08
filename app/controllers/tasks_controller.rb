class TasksController < ApplicationController
  before_action :task, only: :toggle_done

  def index
    base = tasks
    base = base.where(assigned_user_id: current_user.id) if params[:assigned] == 'true'

    today = Date.current
    end_of_week = today.end_of_week

    # Section 1: Due dates (not paginated, typically small)
    due_date_tasks = base.with_due_date.order(due_date: :asc)
    @tasks_overdue = due_date_tasks.where(due_date: ...today)
    @tasks_due_today = due_date_tasks.where(due_date: today.all_day)
    @tasks_due_this_week = due_date_tasks.where(due_date: (today + 1.day)..end_of_week)
    @tasks_due_later = due_date_tasks.where(due_date: (end_of_week + 1.day)..(today + 1.month))
    @has_due_date_tasks = due_date_tasks.exists?

    # Section 2: Starred (no due date)
    @starred_tasks = base.no_due_date.where(star: true).order(id: :desc)

    # Section 3: All tasks, grouped by project
    @tasks = base.order(id: :desc).page(params[:page]).per(100)
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
