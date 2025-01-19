class Project::DocumentsController < Project::BaseController
  before_action :set_document, only: %i[ show destroy edit update ]

  def index
    @documents = project.documents.all
  end

  def show
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def update
    raise 'Not implemented'
  end

  def create
    @document = project.documents.new(document_params)
    @document.user = current_user

    respond_to do |format|
      if @document.save
        format.html { redirect_to project_files_url(project), notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
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

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = project.documents.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:title, :content)
  end
end
