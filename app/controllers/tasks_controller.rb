class TasksController < ApplicationController
  before_action :task, only: :toggle_done

  def index
    base = tasks
    base = base.where(assigned_user_id: current_user.id) if params[:assigned] == 'true'

    today = Date.current

    # Assigned to you
    @assigned_tasks = base.where(assigned_user_id: current_user.id).order(star: :desc, id: :desc)

    # Due soon (exclude assigned tasks to avoid duplicates)
    @tasks_due = base.with_due_date.where(due_date: (today - 1.week)..(today + 2.weeks))
                     .where.not(id: @assigned_tasks).order(due_date: :asc)

    # All remaining tasks: starred first, then the rest
    @tasks = base.where.not(id: @tasks_due)
                 .where.not(id: @assigned_tasks)
                 .order(star: :desc, id: :desc)
                 .page(params[:page]).per(100)
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
