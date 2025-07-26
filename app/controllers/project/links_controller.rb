class Project::LinksController < Project::BaseController
  layout 'project_extra'

  before_action :set_link, only: %i[ show destroy ]
  before_action :set_tab

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
        format.html { redirect_to project_links_url(project), notice: "Link was successfully created." }
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
      format.html { redirect_to project_links_url(project) }
      format.json { head :no_content }
    end
  end

  private

  def set_link
    @link = project.links.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url, :user_id, :project_id)
  end

  def set_tab
    @tab_name = 'Links'
  end
end
