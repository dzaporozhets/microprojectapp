class Project::ActivityController < Project::BaseController
  def show
    @tab_name = 'Team'

    @records = project.activities.includes(:user).order(id: :desc).limit(50)
  end
end
