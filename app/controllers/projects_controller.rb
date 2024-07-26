class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :project, only: %i[ show edit update destroy ]
  before_action :authorize_access, except: [:index, :new, :create]
  before_action :authorize_update, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  layout :set_layout

  # GET /projects or /projects.json
  def index
    personal_project = current_user.personal_project
    user_projects = current_user.projects.without_personal
    invited_projects = current_user.invited_projects

    @projects = []
    @projects << personal_project
    @projects += user_projects
    @projects += invited_projects

    @archived_projects, @projects = @projects.partition { |project| project.archived? }
  end

  # GET /projects/1 or /projects/1.json
  def show
    @tasks_todo = @project.tasks.todo.order(created_at: :desc)
    @tasks_done = @project.tasks.done.order(updated_at: :desc).limit(50)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def project
    @project ||= Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :archived)
  end

  def authorize_update
    if current_user.owns?(project)
      true
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def set_layout
    case action_name
    when 'show' then 'project_with_sidebar'
    when 'edit' then 'project'
    else
      'application'
    end
  end
end
