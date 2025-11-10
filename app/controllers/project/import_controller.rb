class Project::ImportController < Project::BaseController
  before_action :project_owner_only!

  def show
    @imported_tasks = project.tasks.where(id: import_session_data(:task_ids))
    @imported_task_count = import_session_data(:task_count)
    @imported_note_count = import_session_data(:note_count)
    @imported_comment_count = import_session_data(:comment_count)
  end

  def new
  end

  def create
    file = params[:file]
    data = parse_json_file(file)

    validator = ProjectImportValidator.new(file, data)

    unless validator.valid?
      redirect_to new_project_import_path(project), alert: validator.errors.first
      return
    end

    perform_import(data)
  rescue JSON::ParserError
    redirect_to new_project_import_path(project), alert: 'Invalid JSON file.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_project_import_path(project), alert: e.message
  rescue StandardError
    redirect_to new_project_import_path(project),
                alert: 'An error occurred during import. Please try again.'
  end

  private

  def parse_json_file(file)
    return nil if file.nil?

    JSON.parse(file.read)
  end

  def perform_import(data)
    import_service = ProjectImportService.new(project, data, current_user)
    import_service.import!

    store_import_stats(import_service.import_stats)

    redirect_to project_import_path(project), notice: 'Data imported successfully.'
  end

  def store_import_stats(stats)
    session[:imported_task_ids] = stats[:task_ids]
    session[:imported_task_count] = stats[:task_count]
    session[:imported_note_count] = stats[:note_count]
    session[:imported_comment_count] = stats[:comment_count]
  end

  def import_session_data(key)
    session.delete("imported_#{key}".to_sym) || default_value_for(key)
  end

  def default_value_for(key)
    key == :task_ids ? [] : 0
  end
end
