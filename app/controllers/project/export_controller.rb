class Project::ExportController < Project::BaseController
  def new
  end

  def create
    tasks_data = project.tasks.as_json(only: [:name, :description, :done, :done_at, :due_date])

    export_data = {
      project_name: project.name,
      tasks: tasks_data
    }

    filename = "microprojectapp-project-#{project.id}-timestamp-#{Time.now.to_i}.json"

    respond_to do |format|
      format.json { send_data export_data.to_json, filename: filename, type: 'application/json', disposition: 'attachment' }
    end
  end
end
