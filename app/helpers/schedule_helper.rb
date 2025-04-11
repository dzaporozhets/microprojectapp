module ScheduleHelper
  def calendar_url(user, host = nil)
    return nil if user&.calendar_token.blank?

    calendar_schedule_url(
      token: user.calendar_token,
      format: :ics,
      host: host || request.host_with_port
    )
  end

  def due_date_options(existing_due_date = nil)
    options = [
      ['No Due Date', nil],
      ["Tomorrow (#{formatted_date(1.day.from_now.to_date)})", 1.day.from_now.to_date],
      ["Next week (#{formatted_date(1.week.from_now.to_date)})", 1.week.from_now.to_date],
      ["Next month (#{formatted_date(1.month.from_now.to_date)})", 1.month.from_now.to_date],
      [formatted_month(2.months.from_now.beginning_of_month), 2.months.from_now.beginning_of_month],
      [formatted_month(3.months.from_now.beginning_of_month), 3.months.from_now.beginning_of_month],
      [formatted_month(4.months.from_now.beginning_of_month), 4.months.from_now.beginning_of_month],
      [formatted_month(5.months.from_now.beginning_of_month), 5.months.from_now.beginning_of_month],
      [formatted_month(6.months.from_now.beginning_of_month), 6.months.from_now.beginning_of_month]
    ]

    if existing_due_date
      human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
      options.prepend([human_readable_date, existing_due_date])
    end

    options
  end

  private

  def formatted_date(date)
    I18n.l(date, format: :short)
  end

  def formatted_month(date)
    current_year = Date.today.year

    if date.year == current_year
      I18n.l(date, format: '%B')
    else
      I18n.l(date, format: '%B %Y')
    end
  end
end
