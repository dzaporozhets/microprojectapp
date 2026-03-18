module ActivityHelper
  def record_to_text(record)
    case record.trackable_type
    when 'Task'
      task_link = link_to('the task', details_project_task_path(record.project, record.trackable_id), class: 'underline')

      safe_join([record.action, ' ', task_link])
    when 'Note'
      note = record.trackable
      if note
        note_link = link_to('the note', project_note_path(record.project, note), class: 'underline')
        safe_join([record.action, ' ', note_link])
      else
        "#{record.action} a note"
      end
    when 'User'
      target = record.trackable&.email || '(removed)'

      "#{record.action} #{target}"
    end
  end
end
