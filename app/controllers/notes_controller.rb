class NotesController < ApplicationController
  def index
    @notes = Note.where(project_id: current_user.all_active_projects)
                 .includes(:project, :user)
                 .order(id: :desc)
                 .page(params[:page]).per(100)
  end

  def new
    @note = Note.new(project_id: current_user.personal_project&.id)
    @projects = current_user.all_active_projects.reject(&:archived?)
  end

  def create
    @project = current_user.find_active_project(params[:note][:project_id])

    if @project.nil? || @project.archived?
      redirect_to notes_path, alert: "Invalid project."
      return
    end

    @note = @project.notes.new(note_params)
    @note.user = current_user

    if @note.save
      @project.add_activity(current_user, 'created', @note)
      redirect_to notes_path, notice: "Note was successfully created."
    else
      @projects = current_user.all_active_projects.reject(&:archived?)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
