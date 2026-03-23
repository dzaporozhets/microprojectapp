class Project::NotesController < Project::BaseController
  before_action :set_note, only: %i[ show edit update destroy changes ]
  before_action :set_tab

  def index
  end

  def show
  end

  def changes
    @versions = @note.versions.order(created_at: :desc)

    user_ids = @versions.map(&:whodunnit)
    user_ids.compact!
    user_ids.uniq!
    users_by_id = User.where(id: user_ids).index_by(&:id)

    @users_by_version = @versions.each_with_object({}) do |version, hash|
      hash[version.id] = users_by_id[version.whodunnit.to_i]
    end
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = project.notes.new(note_params)
    @note.user = current_user

    respond_to do |format|
      if @note.save
        @project.add_activity(current_user, 'created', @note)
        format.html { redirect_to project_notes_path(@project), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to project_note_path(@project, @note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy!
    @project.add_activity(current_user, 'removed', @note)

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
    permitted = params.require(:note).permit(:title, :content, :attachment)
    permitted.delete(:attachment) unless file_storage_enabled?
    permitted
  end

  def set_tab
    @tab_name = 'Notes'
  end
end
