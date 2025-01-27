class Project::DocumentsController < Project::BaseController
  before_action :set_document, only: %i[ show destroy edit update history version]
  before_action :set_tab, only: %i[ show edit index history version ]

  def index
    @documents = project.documents.all
  end

  def show
  end

  def history
    @versions = @document.versions.order(created_at: :desc)

    user_ids = @versions.map(&:whodunnit).compact.uniq
    users_by_id = User.where(id: user_ids).index_by(&:id)

    @users_by_version = @versions.each_with_object({}) do |version, hash|
      hash[version.id] = users_by_id[version.whodunnit.to_i]
    end
  end

  def version
    @version = @document.versions.find(params[:version_id])
  end

  def new
    @document = project.documents.new(title: 'New Document')
    @document.user = current_user
    @document.save

    redirect_to edit_project_document_path(@project, @document)
  end

  def edit
  end

  def update
    @document.update(document_params)

    respond_to do |format|
      format.html { redirect_to edit_project_document_path(@project, @document), notice: 'Saved' }
    end
  end

  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to project_files_url(project) }
      format.json { head :no_content }
    end
  end

  private

  def set_document
    @document = project.documents.find(params[:id])
  end

  def set_tab
    @tab_name = 'Files'
  end

  def document_params
    params.require(:document).permit(:title, :content)
  end
end
