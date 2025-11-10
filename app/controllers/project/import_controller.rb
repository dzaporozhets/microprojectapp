class Project::ImportController < Project::BaseController
  before_action :project_owner_only!
  MAX_FILE_SIZE = 5.megabytes # Set the file size limit

  def show
    task_ids = session.delete(:imported_task_ids) || []

    @imported_tasks = project.tasks.where(id: task_ids)
    @imported_task_count = session.delete(:imported_task_count) || 0
    @imported_note_count = session.delete(:imported_note_count) || 0
    @imported_comment_count = session.delete(:imported_comment_count) || 0
  end
  def new
  end

  def create
    file = params[:file]

    unless file
      redirect_to new_project_import_path(project), alert: 'Please upload a file.'
      return
    end

    if file.size > MAX_FILE_SIZE
      redirect_to new_project_import_path(project), alert: "File size should be less than #{MAX_FILE_SIZE / 1.megabyte} MB."
      return
    end

    begin
      data = JSON.parse(file.read)

      # Validate that tasks is an array
      tasks = data['tasks']
      unless tasks.is_a?(Array)
        redirect_to new_project_import_path(project), alert: 'Invalid JSON file format: tasks should be an array.'
        return
      end

      # Validate that notes (if present) is an array
      notes = data['notes'] || []
      unless notes.is_a?(Array)
        redirect_to new_project_import_path(project), alert: 'Invalid JSON file format: notes should be an array.'
        return
      end

      # Optionally limit the number of records imported to prevent abuse
      max_import_count = Task::TASK_LIMIT
      if tasks.size > max_import_count || notes.size > max_import_count
        redirect_to new_project_import_path(project), alert: "Too many tasks or notes. Maximum allowed is #{max_import_count} items each."
        return
      end

      imported_tasks = []
      imported_notes = []
      imported_comment_count = 0

      # Use a transaction for atomicity
      Project.transaction do
        tasks.each do |task_data|
          # Ensure each task_data is a Hash
          unless task_data.is_a?(Hash)
            raise ActiveRecord::RecordInvalid.new('Invalid task data format.')
          end
          comments_data = extract_comments(task_data)
          task_params = task_data.slice('name', 'description', 'done', 'done_at', 'due_date').merge(user: current_user)
          task = project.tasks.create!(task_params)
          imported_tasks << task
          imported_comment_count += create_comments_for(task, comments_data)
        end

        notes.each do |note_data|
          unless note_data.is_a?(Hash)
            raise ActiveRecord::RecordInvalid.new('Invalid note data format.')
          end
          note_params = note_data.slice('title', 'content').merge(user: current_user)
          imported_notes << project.notes.create!(note_params)
        end
      end

      # Store only a subset of IDs (first 10) for UI preview purposes
      first_ten_tasks = imported_tasks.first(10)
      session[:imported_task_ids] = first_ten_tasks.map(&:id)
      session[:imported_task_count] = imported_tasks.size
      session[:imported_note_count] = imported_notes.size
      session[:imported_comment_count] = imported_comment_count

      redirect_to project_import_path(project), notice: 'Data imported successfully.'
    rescue JSON::ParserError
      redirect_to new_project_import_path(project), alert: 'Invalid JSON file.'
    rescue ActiveRecord::RecordInvalid => e
      redirect_to new_project_import_path(project), alert: e.message
    rescue StandardError
      # Catch all other errors to prevent unhandled exceptions and reveal less internal info
      redirect_to new_project_import_path(project), alert: 'An error occurred during import. Please try again.'
    end
  end

  private

  def extract_comments(task_data)
    comments = task_data['comments'] || []
    unless comments.is_a?(Array)
      raise ActiveRecord::RecordInvalid.new('Invalid JSON file format: comments should be an array.')
    end
    comments
  end

  def create_comments_for(task, comments_data)
    comments_data.reduce(0) do |count, comment_data|
      unless comment_data.is_a?(Hash)
        raise ActiveRecord::RecordInvalid.new('Invalid comment data format.')
      end

      body = comment_data['body'].to_s.strip
      next count if body.blank?

      user = find_comment_user(comment_data['user_email'])
      task.comments.create!(body: body, user: user)
      count + 1
    end
  end

  def find_comment_user(email)
    return current_user if email.blank?

    User.find_by(email: email) || current_user
  end

end
