class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    projects = @current_api_user.all_active_projects

    render json: {
      projects: projects.map { |p| { id: p.id, name: p.name } }
    }
  end
end
