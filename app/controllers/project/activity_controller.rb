class Project::ActivityController < Project::BaseController
  PER_PAGE = 100

  def show
    @tab_name = 'Activity'

    @records = project.activities.includes(:user).order(id: :desc).page(params[:page]).per(PER_PAGE)
  end
end
