module ActivityHelper
  def record_to_text(record)
    case record.trackable_type
    when 'Task'
      task_link = link_to('the task', details_project_task_path(record.project, record.trackable_id), class: 'underline')

      "#{record.action} #{task_link}".html_safe
    when 'User'
      target = record.trackable&.email || '(removed)'

      "#{record.action} #{target}"
    end
  end
end
