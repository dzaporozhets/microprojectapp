class Project::NotesController < Project::BaseController
  before_action :set_note, only: %i[ show destroy ]
  before_action :set_tab

  def index
  end

  def show
  end

  def new
    @note = Note.new
  end

  def create
    @note = project.notes.new(note_params)
    @note.user = current_user

    respond_to do |format|
      if @note.save
        format.html { redirect_to project_notes_path(@project), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to project_notes_path(@project) }
      format.json { head :no_content }
    end
  end

  private

  def set_note
    @note = project.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end

  def set_tab
    @tab_name = 'Extra'
  end
end
