class Api::V1::BaseController < ActionController::Base # rubocop:disable Rails/ApplicationController
  skip_forgery_protection

  before_action :authenticate_api_user!
  before_action :set_project
  before_action :authorize_api_access

  private

  def authenticate_api_user!
    token = request.headers['Authorization']&.delete_prefix('Bearer ')

    if token.blank?
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    @current_api_user = User.authenticate_by_api_token(token)

    unless @current_api_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def set_project
    @project = Project.find_by(id: params[:project_id])

    unless @project
      render json: { error: 'Not found' }, status: :not_found
    end
  end

  def authorize_api_access
    return unless @current_api_user && @project

    unless @current_api_user.has_access_to?(@project)
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end
