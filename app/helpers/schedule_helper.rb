module ScheduleHelper
  def due_date_options(existing_due_date = nil)
    options = [
      ['No Due Date', nil],
      ["Tomorrow (+1 day)", 1.day.from_now.to_date],
      ["Monday (+#{days_until_next_monday} days)", next_monday.to_date],
      ["Two Weeks from Now (+14 days)", 2.weeks.from_now.to_date],
      ["Four Weeks from Now (+28 days)", 4.weeks.from_now.to_date],
      ["Eight Weeks from Now (+56 days)", 8.weeks.from_now.to_date]
    ]

    if existing_due_date
      human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
      days_difference = (existing_due_date.to_date - Date.today).to_i
      options.prepend(["#{human_readable_date} (+#{days_difference} days)", existing_due_date])
    end

    options
  end

  private

  def days_until_next_monday
    today = Date.today
    days_until_monday = (1 - today.wday) % 7
    days_until_monday = 7 if days_until_monday == 0
    days_until_monday
  end

  def next_monday
    Date.today + days_until_next_monday
  end
end
