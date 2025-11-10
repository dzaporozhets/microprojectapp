# frozen_string_literal: true

# Serializes a task with its comments for export
class TaskExportSerializer
  def initialize(task)
    @task = task
  end

  def as_json
    @task.as_json(only: [:name, :description, :done, :done_at, :due_date]).merge(
      'comments' => serialize_comments
    )
  end

  private

  def serialize_comments
    @task.comments.order(:id).map do |comment|
      {
        'body' => comment.body,
        'user_email' => comment.user.email
      }
    end
  end
end
