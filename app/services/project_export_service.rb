# frozen_string_literal: true

# Service object to handle project data export
class ProjectExportService
  def initialize(project)
    @project = project
  end

  def export_data
    {
      project_name: @project.name,
      tasks: serialize_tasks
    }
  end

  def filename
    "microprojectapp-project-#{@project.id}-timestamp-#{Time.now.to_i}.json"
  end

  private

  def serialize_tasks
    @project.tasks.includes(comments: :user).order(:id).map do |task|
      TaskExportSerializer.new(task).as_json
    end
  end
end
