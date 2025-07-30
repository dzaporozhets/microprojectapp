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

  def calendar_day_classes(day, count, is_today, is_current_month)
    classes = [
      "mx-auto flex size-6 items-center justify-center rounded-full transition"
    ]

    if is_today
      classes << "ring-2 ring-red-300 text-black dark:ring-red-500 font-semibold dark:text-red-500"
    elsif count > 0
      classes << "#{theme_bg} font-semibold"
    elsif is_current_month
      classes << "text-gray-900 dark:text-gray-100"
    else
      classes << "text-gray-400"
    end

    classes.join(" ")
  end

  def render_calendar_month(date, daily_task_counts)
    start_day = date.beginning_of_month.beginning_of_week(:monday)
    end_day = date.end_of_month.end_of_week(:monday)

    content_tag(:div, class: "calendar-month") do
      concat(calendar_month_header(date))
      concat(calendar_day_headings)
      concat(calendar_days_grid(start_day, end_day, daily_task_counts, date))
    end
  end

  private

  def calendar_month_header(date)
    content_tag(:div, class: "flex items-center justify-center mb-4") do
      content_tag(:h3, date.strftime("%B"), class: "text-sm font-semibold text-gray-900 dark:text-gray-100")
    end
  end

  def calendar_day_headings
    content_tag(:div, class: "grid grid-cols-7 text-center text-xs text-gray-500 dark:text-gray-400") do
      Date::ABBR_DAYNAMES.rotate(1).each do |day|
        concat(content_tag(:div, day.first))
      end
    end
  end

  def calendar_days_grid(start_day, end_day, daily_task_counts, current_month_date)
    content_tag(:div, class: "mt-2 grid grid-cols-7 text-xs") do
      (start_day..end_day).each do |day|
        count = daily_task_counts[day] || 0
        is_today = day == Date.current
        is_current_month = day.month == current_month_date.month

        classes = calendar_day_classes(day, count, is_today, is_current_month)

        concat(
          content_tag(:div, class: "py-1 border-t border-gray-200 dark:border-gray-700") do
            content_tag(:div, class: classes) do
              content_tag(:time, day.day, datetime: day.iso8601)
            end
          end
        )
      end
    end
  end

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
