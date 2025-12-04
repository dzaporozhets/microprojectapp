class Project::NotesController < Project::BaseController
  before_action :set_note, only: %i[ show destroy edit update history version]
  before_action :set_tab, only: %i[ show edit index history version ]

  def index
    redirect_to overview_project_path(@project)
  end

  def show
  end

  def history
    @versions = @note.versions.order(created_at: :desc)

    user_ids = @versions.map(&:whodunnit)
    user_ids.compact!
    user_ids.uniq!
    users_by_id = User.where(id: user_ids).index_by(&:id)

    @users_by_version = @versions.each_with_object({}) do |version, hash|
      hash[version.id] = users_by_id[version.whodunnit.to_i]
    end
  end

  def version
    @version = @note.versions.find(params[:version_id])
  end

  def new
    @note = project.notes.new(title: 'New Note')
    @note.user = current_user

    if @note.save
      @project.add_activity(current_user, 'created', @note)

      redirect_to edit_project_note_path(@project, @note)
    else
      record_not_found
    end
  end

  def edit
  end

  def update
    @note.update(note_params)

    respond_to do |format|
      format.html { redirect_to edit_project_note_path(@project, @note), notice: 'Saved' }
    end
  end

  def destroy
    @note.destroy!
    @project.add_activity(current_user, 'removed', @note)

    respond_to do |format|
      format.html { redirect_to overview_project_path(@project) }
      format.json { head :no_content }
    end
  end

  private

  def set_note
    @note = project.notes.find(params[:id])
  end

  def set_tab
    @tab_name = 'Project'
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
