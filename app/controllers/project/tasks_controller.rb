class Project::TasksController < Project::BaseController
  PER_PAGE = 100

  before_action :set_task, only: %i[ show edit update destroy details toggle_done toggle_star changes]
  before_action :set_tab, only: %i[ details changes index completed]

  def index
    if params[:assigned_user_id].present?
      @tasks = assigned_tasks
    else
      @tasks = @project.tasks.basic_order
    end

    @tasks = @tasks.page(params[:page]).per(PER_PAGE)
  end

  def completed
    @tasks = done_tasks
    @tasks = @tasks.page(params[:page]).per(PER_PAGE)
  end

  def show
  end

  def changes
    @versions = @task.versions.order(created_at: :desc)

    user_ids = @versions.map(&:whodunnit)
    user_ids.compact!
    user_ids.uniq!
    users_by_id = User.where(id: user_ids).index_by(&:id)

    @users_by_version = @versions.each_with_object({}) do |version, hash|
      hash[version.id] = users_by_id[version.whodunnit.to_i]
    end
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = project.tasks.new(task_params)
    @task.user = current_user

    respond_to do |format|
      if @task.save
        @project.add_activity(current_user, 'created', @task)

        format.turbo_stream
        format.html { redirect_to project_url(@project), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.turbo_stream
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        # When we change task name or description,
        # we just update a single item with a task
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: "project/tasks/task", locals: { task: @task })
        end

        format.html { redirect_to details_project_task_url(@project, @task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "project/tasks/edit_form", locals: { task: @task }) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    @project.add_activity(current_user, 'removed', @task)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("task_#{@task.id}") }
      format.html { redirect_to project_url(@project), notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def details
  end

  def toggle_done
    respond_to do |format|
      if @task.update(params.require(:task).permit(:done))
        @project.add_activity(current_user, (@task.done ? 'closed' : 'opened'), @task)

        # If tasks was marked as done (or undone), we rebuild the list
        # so the done task is going under "done" section
        # and and vice versa
        # tasks

        format.turbo_stream
        format.html { redirect_back fallback_location: project_path(@project), notice: "Task status was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { redirect_back fallback_location: project_path(@project), alert: 'Failed to update task status.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_star
    @task.star = !@task.star

    if @task.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to project_url(@project), notice: "Task star status was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      end
    else
      respond_to do |format|
        format.html { redirect_to project_url(@project), alert: 'Failed to update task star status.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def done_tasks
    @project.tasks.done.order(updated_at: :desc)
  end

  def none_tasks
    @project.tasks.none
  end

  def assigned_tasks
    @project.tasks.basic_order.where(assigned_user_id: params[:assigned_user_id].to_i)
  end

  def set_task
    @task = project.tasks.find(params[:id])
  end

  def task_params
    @task_params ||= filter_params(params.require(:task).permit(:name, :description, :done, :due_date, :assigned_user_id, :note_id))
  end

  def filter_params(permitted_params)
    if permitted_params[:assigned_user_id].present?
      unless project.find_user(permitted_params[:assigned_user_id])
        permitted_params.delete(:assigned_user_id)

        flash[:alert] = 'Assigned user must be a member of the project team.'
      end
    end

    permitted_params
  end

  def set_tab
    @tab_name = 'Tasks'
  end
end
