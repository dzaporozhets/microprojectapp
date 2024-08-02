class Project::ImportController < Project::BaseController
  def new
  end

  def create
    file = params[:file]

    if file
      begin
        data = JSON.parse(file.read)

        data["tasks"].each do |task_data|
          task_params = task_data.except("id", "created_at", "updated_at").merge(user: current_user)
          project.tasks.create!(task_params)
        end

        redirect_to project, notice: 'Tasks were successfully imported.'
      rescue JSON::ParserError => e
        redirect_to new_project_import_path(project), alert: 'Invalid JSON file.'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to new_project_import_path(project), alert: e.message
      end
    else
      redirect_to new_project_import_path(project), alert: 'Please upload a file.'
    end
  end
end
