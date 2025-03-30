module TasksHelper
  def dom_task_comments_id(task)
    "task_#{task.id}_comments"
  end

  def dom_task_comment_form_id(task)
    "task_#{task.id}_new_comment"
  end

  def collapse_task_path
    referer_uri = URI.parse(request.referer) rescue nil
    return project_path(@project) unless referer_uri && referer_uri.path

    if referer_uri.path.ends_with?(project_schedule_path(@project))
      project_schedule_path(@project)
    elsif referer_uri.path.ends_with?(project_tasks_path(@project))
      project_tasks_path(@project)
    elsif referer_uri.path.ends_with?(completed_project_tasks_path(@project))
      completed_project_tasks_path(@project)
    elsif referer_uri.path.ends_with?(project_path(@project))
      project_path(@project)
    elsif referer_uri.path.ends_with?('/tasks')
      tasks_path
    elsif referer_uri.path.ends_with?('/schedule')
      schedule_path
    elsif referer_uri.path.ends_with?('/activity')
      project_activity_path(@project)
    else
      project_path(@project)
    end
  end

  def task_star_icon(task)
    return unless task.star

    render 'project/tasks/star', task: task
  end

  def tasks_lists_page?
    current_page?(project_path(@project)) ||
      current_page?(completed_project_tasks_path(@project)) ||
      current_page?(project_tasks_path(@project)) ||
      current_page?(project_schedule_path(@project))
  end
end
