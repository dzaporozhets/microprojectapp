class SearchController < ApplicationController
  MIN_QUERY_LENGTH = 3
  RESULT_LIMIT = 50

  def index
    @query = params[:query].to_s.strip
    @min_query_length = MIN_QUERY_LENGTH
    @can_search = @query.length >= MIN_QUERY_LENGTH
    @task_results = []
    @note_results = []
    @link_results = []

    return unless @can_search

    projects = current_user.all_active_projects
    query_like = "%#{@query}%"

    @task_results = Task
      .includes(:project)
      .where(project_id: projects)
      .where("tasks.name ILIKE ?", query_like)
      .order(created_at: :desc)
      .limit(RESULT_LIMIT)

    @note_results = Note
      .includes(:project)
      .where(project_id: projects)
      .where("notes.title ILIKE ?", query_like)
      .order(created_at: :desc)
      .limit(RESULT_LIMIT)

    @link_results = Link
      .includes(:project)
      .where(project_id: projects)
      .where("links.title ILIKE :query OR links.url ILIKE :query", query: query_like)
      .order(created_at: :desc)
      .limit(RESULT_LIMIT)
  end
end
