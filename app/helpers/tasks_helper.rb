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

  def due_date_options(existing_due_date = nil)
    options = [
      ['No Due Date', nil],
      ['Tomorrow', 1.day.from_now.to_date],
      ['Next Week', 1.week.from_now.to_date],
      ['Next Month', 1.month.from_now.to_date],
      ['Next Year', 1.year.from_now.to_date]
    ]

    if existing_due_date
      human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
      options.prepend([human_readable_date, existing_due_date])
    end

    options
  end
end
