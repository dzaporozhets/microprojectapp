class Project::LinksController < Project::BaseController
  before_action :set_link, only: %i[ show destroy ]

  def index
    @links = project.links.all
  end

  def show
  end

  def new
    @link = Link.new
  end

  def create
    @link = project.links.new(link_params)
    @link.user = current_user

    respond_to do |format|
      if @link.save
        format.html { redirect_to project_files_url(project), notice: "Link was successfully created." }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @link.destroy!

    respond_to do |format|
      format.html { redirect_to project_files_url(project) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = project.links.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:title, :url, :user_id, :project_id)
  end
end
