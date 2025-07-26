class Project::ActivityController < Project::BaseController
  layout 'project_extra'

  def show
    @tab_name = 'Activity'

    @records = project.activities.includes(:user).order(id: :desc).limit(50)
  end
end
