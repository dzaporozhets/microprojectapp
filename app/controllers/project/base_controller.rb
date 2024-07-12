class Project::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :project
  before_action :authorize_access

  layout 'project'

  def project
    @project ||= Project.find(params[:project_id])
  end
end
