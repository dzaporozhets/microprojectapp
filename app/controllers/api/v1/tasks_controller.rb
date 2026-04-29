class Api::V1::TasksController < Api::V1::BaseController
  before_action :set_task, only: %i[show toggle_done]

  def index
    tasks = case params[:status]
            when 'todo'
              @project.tasks.todo.basic_order
            when 'done'
              @project.tasks.done.order(updated_at: :desc)
            else
              @project.tasks.basic_order
            end

    if params[:due].present?
      tasks = filter_by_due(tasks, params[:due])
      return if performed?
    end

    if params[:assigned].present?
      tasks = filter_by_assigned(tasks, params[:assigned])
      return if performed?
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

  def create
    if @project.archived?
      render json: { error: 'Cannot add tasks to an archived project' }, status: :unprocessable_entity
      return
    end

    @task = @project.tasks.new(task_params)
    @task.user = @current_api_user

    if @task.save
      @project.add_activity(@current_api_user, 'created', @task)
      render json: { task: task_detail(@task, []) }, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
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

  def filter_by_due(scope, value)
    case value
    when 'today'
      scope.where(due_date: Date.current)
    when 'overdue'
      scope.todo.where(due_date: ...Date.current)
    when 'this_week'
      scope.where(due_date: Date.current.all_week)
    when 'none'
      scope.no_due_date
    else
      date = Date.parse(value) rescue nil

      if date
        scope.where(due_date: date)
      else
        render json: { error: "Invalid due filter: #{value}. Use today, overdue, this_week, none, or YYYY-MM-DD." }, status: :bad_request
        nil
      end
    end
  end

  def filter_by_assigned(scope, value)
    case value
    when 'me'
      scope.where(assigned_user_id: @current_api_user.id)
    when 'unassigned'
      scope.where(assigned_user_id: nil)
    else
      if value.match?(/\A\d+\z/)
        scope.where(assigned_user_id: value.to_i)
      else
        render json: { error: "Invalid assigned filter: #{value}. Use me, unassigned, or a numeric user ID." }, status: :bad_request
        nil
      end
    end
  end

  def set_task
    @task = @project.tasks.find_by(id: params[:id])

    unless @task
      render json: { error: 'Not found' }, status: :not_found
    end
  end

  def task_params
    permitted = params.require(:task).permit(:name, :description, :due_date, :star, :assigned_user_id)

    if permitted[:assigned_user_id].present?
      unless @project.find_user(permitted[:assigned_user_id])
        permitted.delete(:assigned_user_id)
      end
    end

    permitted
  end

  def task_summary(task)
    {
      id: task.id,
      name: task.name,
      done: task.done,
      star: task.star,
      due_date: task.due_date,
      done_at: task.done_at,
      assigned_user_id: task.assigned_user_id,
      assigned_user_email: task.assigned_user&.email,
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
