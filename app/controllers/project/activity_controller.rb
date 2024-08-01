class Project::ActivityController < Project::BaseController
  layout 'project_with_sidebar', only: [:show]

  def show
    @records = project.activities.includes(:user).order(id: :desc).limit(50)
  end
end
