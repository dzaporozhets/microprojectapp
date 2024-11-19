class Project::PinsController < Project::BaseController
  def create
    current_user.pinned_projects << project unless current_user.pinned_projects.include?(project)

    redirect_to project_path(project), notice: "Project pinned successfully."
  end

  def destroy
    current_user.pinned_projects.delete(project)

    redirect_to project_path(project), notice: "Project unpinned successfully."
  end
end
