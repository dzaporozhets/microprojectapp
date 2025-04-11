module ActivityHelper
  def record_to_text(record)
    case record.trackable_type
    when 'Task'
      task_link = link_to('the task', details_project_task_path(record.project, record.trackable_id), class: 'underline')

      safe_join([record.action, ' ', task_link])
    when 'Note'
      note_link = link_to('the note', edit_project_note_path(record.project, record.trackable_id), class: 'underline')

      safe_join([record.action, ' ', note_link])
    when 'User'
      target = record.trackable&.email || '(removed)'

      "#{record.action} #{target}"
    end
  end
end
