class Api::V1::TasksController < Api::V1::BaseController
  before_action :set_task, only: [:show, :toggle_done]

  def index
    tasks = case params[:status]
            when 'todo'
              @project.tasks.todo.basic_order
            when 'done'
              @project.tasks.done.order(updated_at: :desc)
            else
              @project.tasks.basic_order
            end

    render json: {
      project: { id: @project.id, name: @project.name },
      tasks: tasks.map { |t| task_summary(t) }
    }
  end

  def show
    comments = @task.comments.where(removed_at: nil).order(created_at: :asc)

    render json: {
      task: task_detail(@task, comments)
    }
  end

  def toggle_done
    new_done = !@task.done

    if @task.update(done: new_done)
      @project.add_activity(@current_api_user, (new_done ? 'closed' : 'opened'), @task)
      render json: { task: task_summary(@task) }
    else
      render json: { error: 'Failed to update task' }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = @project.tasks.find_by(id: params[:id])

    unless @task
      render json: { error: 'Not found' }, status: :not_found
    end
  end

  def task_summary(task)
    {
      id: task.id,
      name: task.name,
      done: task.done,
      star: task.star,
      due_date: task.due_date,
      done_at: task.done_at,
      created_at: task.created_at,
      updated_at: task.updated_at,
      comment_count: task.comments.size
    }
  end

  def task_detail(task, comments)
    {
      id: task.id,
      name: task.name,
      description: task.description,
      done: task.done,
      star: task.star,
      due_date: task.due_date,
      done_at: task.done_at,
      assigned_user_email: task.assigned_user&.email,
      created_at: task.created_at,
      updated_at: task.updated_at,
      comments: comments.map { |c|
        {
          id: c.id,
          body: c.body,
          user_email: c.user_email,
          created_at: c.created_at
        }
      }
    }
  end
end
