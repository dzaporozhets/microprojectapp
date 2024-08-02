class Project::ImportController < Project::BaseController
  MAX_FILE_SIZE = 5.megabytes # Set the file size limit

  def new
  end

  def create
    file = params[:file]

    if file

      if file.size > MAX_FILE_SIZE
        redirect_to new_project_import_path(project), alert: "File size should be less than #{MAX_FILE_SIZE / 1.megabyte} MB."

        return
      end

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
