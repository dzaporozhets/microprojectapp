module ScheduleHelper
  def due_date_options(existing_due_date = nil)
    options = [
      ['No Due Date', nil],
      ["Tomorrow (#{formatted_date(1.day.from_now.to_date)})", 1.day.from_now.to_date],
      ["Monday (#{formatted_date(next_monday)})", next_monday.to_date],
      ["In Two Weeks (#{formatted_date(2.weeks.from_now.to_date)})", 2.weeks.from_now.to_date],
      ["In Four Weeks (#{formatted_date(4.weeks.from_now.to_date)})", 4.weeks.from_now.to_date],
      ["In Eight Weeks (#{formatted_date(8.weeks.from_now.to_date)})", 8.weeks.from_now.to_date]
    ]

    if existing_due_date
      human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
      options.prepend([human_readable_date, existing_due_date])
    end

    options
  end

  private

  def formatted_date(date)
    date.strftime('%b %d')
  end

  def days_until_next_monday
    today = Date.today
    (1 - today.wday) % 7 + (today.wday.zero? ? 7 : 0)
  end

  def next_monday
    Date.today + days_until_next_monday
  end
end
