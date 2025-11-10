class Project::ExportController < Project::BaseController
  before_action :project_owner_only!

  def new
  end

  def create
    tasks_data = project.tasks.includes(comments: :user).order(:id).map do |task|
      task.as_json(only: [:name, :description, :done, :done_at, :due_date]).merge(
        'comments' => task.comments.order(:id).map do |comment|
          {
            'body' => comment.body,
            'user_email' => comment.user.email
          }
        end
      )
    end
    notes_data = project.notes.as_json(only: [:title, :content])

    export_data = {
      project_name: project.name,
      tasks: tasks_data,
      notes: notes_data
    }

    filename = "microprojectapp-project-#{project.id}-timestamp-#{Time.now.to_i}.json"

    respond_to do |format|
      format.json { send_data export_data.to_json, filename: filename, type: 'application/json', disposition: 'attachment' }
    end
  end
end
