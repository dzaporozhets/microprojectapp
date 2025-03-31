class Project::UsersController < Project::BaseController
  layout 'project_extra'

  before_action :not_personal
  before_action :project_owner_only!, except: [:index, :leave]
  before_action :set_tab

  def index
  end

  def invite
  end

  def add_member
    user = User.find_by(email: params[:email])

    if user
      if user.allow_invites
        if project.user != user && project.users.exclude?(user)
          if project.users << user
            project.add_activity(current_user, 'invited', user)

            redirect_to project_users_path(project)
            return
          else
            error = 'User could not be added.'
          end
        else
          error = 'User is already added to the project'
        end
      else
        error = 'User disabled invitations'
      end
    else
      error = 'User not found'
    end

    redirect_to invite_project_users_path(@project), alert: error
  end

  def destroy
    user = User.find(params[:id])

    if project.users.include?(user)
      project.users.delete(user)

      redirect_to project_activity_path(project), notice: 'User was successfully removed.'
    else
      redirect_to project_activity_path(project), alert: 'User could not be found or removed.'
    end
  end

  def leave
    if project.users.include?(current_user)
      project.users.delete(current_user)

      redirect_to projects_path, notice: 'You left the project.'
    end
  end

  private

  def not_personal
    redirect_to root_path if project.personal?
  end

  def set_tab
    @tab_name = 'Project'
  end
end
