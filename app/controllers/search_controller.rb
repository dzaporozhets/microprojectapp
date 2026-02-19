class SearchController < ApplicationController
  MIN_QUERY_LENGTH = 3
  RESULT_LIMIT = 50

  def index
    @query = params[:query].to_s.strip
    @min_query_length = MIN_QUERY_LENGTH
    @can_search = @query.length >= MIN_QUERY_LENGTH
    @task_results = []

    return unless @can_search

    projects = current_user.all_active_projects

    @task_results = Task
      .includes(:project)
      .where(project_id: projects)
      .where("tasks.name ILIKE ?", "%#{@query}%")
      .order(created_at: :desc)
      .limit(RESULT_LIMIT)
  end
end
