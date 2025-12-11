class SearchController < ApplicationController
  MIN_QUERY_LENGTH = 3

  def index
    @query = params[:query].to_s.strip
    @min_query_length = MIN_QUERY_LENGTH
    @can_search = @query.length >= MIN_QUERY_LENGTH
    @results = []

    return unless @can_search

    @results = Task
      .includes(:project)
      .where(project_id: current_user.all_active_projects)
      .where("tasks.name ILIKE ?", "%#{@query}%")
      .order(created_at: :desc)
      .limit(50)
  end
end
