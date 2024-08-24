module TasksHelper
  def calc_textarea_rows(text, default_rows = 4)
    return default_rows if text.blank?

    # Split the text into lines and count them
    lines = text.split("\n").size

    # Return the greater value between the number of lines and the default rows.
    # But keep it 20 or less
    [[lines, default_rows].max, 20].min
  end

  def dom_task_comments_id(task)
    "task_#{task.id}_comments"
  end

  def dom_task_comment_form_id(task)
    "task_#{task.id}_new_comment"
  end

  def collapse_task_path
    referer_uri = URI.parse(request.referer) rescue nil
    return project_tasks_path(@project) unless referer_uri && referer_uri.path

    if referer_uri.path.ends_with?(project_schedule_path(@project))
      project_schedule_path(@project)
    elsif referer_uri.path.ends_with?('/schedule')
      schedule_path
    elsif referer_uri.path.ends_with?('/activity')
      project_activity_path(@project)
    else
      project_tasks_path(@project)
    end
  end

  def task_star_icon(task)
    return unless task.star

    content_tag :span, class: 'inline-block text-yellow-400 mr-2' do
      render 'project/tasks/star', task: task
    end
  end
end
