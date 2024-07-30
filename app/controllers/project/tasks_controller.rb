class Project::TasksController < Project::BaseController
  before_action :set_task, only: %i[ show edit update destroy details expand toggle_done ]

  layout :set_layout

  # GET /tasks or /tasks.json
  def index
    tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = project.tasks.new(task_params)
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.turbo_stream
        format.html { redirect_to project_url(@project), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { redirect_to project_url(@project), alert: 'Task could not be created.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "project/tasks/task", locals: { task: @task }) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("task_#{@task.id}") }
      format.html { redirect_to project_url(@project), notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def details
  end

  def expand
  end

  def toggle_done
    respond_to do |format|
      if @task.update(params.require(:task).permit(:done))
        # If tasks was marked as done (or undone), we rebuild the list
        # so the done task is going under "done" section
        # and and vice versa
        tasks

        format.turbo_stream
        format.html { redirect_to project_url(@project), notice: "Task status was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { redirect_to project_url(@project), alert: 'Failed to update task status.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def tasks
    if params[:status] == 'done'
      @tasks_todo = @project.tasks.none
    else
      @tasks_todo = @project.tasks.todo.order(created_at: :desc)
    end

    @tasks_done = @project.tasks.done.order(updated_at: :desc).page(params[:page]).per(100)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = project.tasks.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:name, :description, :done, :due_date)
  end

  def set_layout
    action_name == 'index' ? 'project_with_sidebar' : 'project'
  end
end
