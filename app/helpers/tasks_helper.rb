module TasksHelper
  def calc_textarea_rows(text, default_rows = 4)
    return default_rows if text.blank?

    # Split the text into lines and count them
    lines = text.split("\n").size

    # Return the greater value between the number of lines and the default rows
    [(lines * 1.5).round, default_rows].max
  end

  def dom_task_comments_id(task)
    "task_#{task.id}_comments"
  end

  def dom_task_comment_form_id(task)
    "task_#{task.id}_new_comment"
  end
end
