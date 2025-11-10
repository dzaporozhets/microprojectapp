# frozen_string_literal: true

# Service object to handle project data import
class ProjectImportService
  attr_reader :imported_tasks, :imported_notes, :imported_comment_count

  def initialize(project, data, current_user)
    @project = project
    @data = data
    @current_user = current_user
    @imported_tasks = []
    @imported_notes = []
    @imported_comment_count = 0
  end

  def import!
    Project.transaction do
      import_tasks
      import_notes
    end
  end

  def import_stats
    {
      task_ids: @imported_tasks.first(10).map(&:id),
      task_count: @imported_tasks.size,
      note_count: @imported_notes.size,
      comment_count: @imported_comment_count
    }
  end

  private

  def import_tasks
    tasks = @data['tasks'] || []

    tasks.each do |task_data|
      validate_hash!(task_data, 'Invalid task data format.')

      comments_data = extract_comments(task_data)
      task = create_task(task_data)

      @imported_tasks << task
      @imported_comment_count += import_comments_for(task, comments_data)
    end
  end

  def import_notes
    notes = @data['notes'] || []

    notes.each do |note_data|
      validate_hash!(note_data, 'Invalid note data format.')

      note = create_note(note_data)
      @imported_notes << note
    end
  end

  def create_task(task_data)
    task_params = task_data.slice('name', 'description', 'done', 'done_at', 'due_date')
                           .merge(user: @current_user)
    @project.tasks.create!(task_params)
  end

  def create_note(note_data)
    note_params = note_data.slice('title', 'content').merge(user: @current_user)
    @project.notes.create!(note_params)
  end

  def extract_comments(task_data)
    comments = task_data['comments'] || []
    validate_array!(comments, 'Invalid JSON file format: comments should be an array.')
    comments
  end

  def import_comments_for(task, comments_data)
    comments_data.count do |comment_data|
      validate_hash!(comment_data, 'Invalid comment data format.')

      body = comment_data['body'].to_s.strip
      next false if body.blank?

      user = find_comment_user(comment_data['user_email'])
      task.comments.create!(body: body, user: user)
      true
    end
  end

  def find_comment_user(email)
    return @current_user if email.blank?

    User.find_by(email: email) || @current_user
  end

  def validate_hash!(value, error_message)
    raise ActiveRecord::RecordInvalid, error_message unless value.is_a?(Hash)
  end

  def validate_array!(value, error_message)
    raise ActiveRecord::RecordInvalid, error_message unless value.is_a?(Array)
  end
end
