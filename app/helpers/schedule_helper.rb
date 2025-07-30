module ScheduleHelper
  def calendar_url(user, host = nil)
    return nil if user&.calendar_token.blank?

    calendar_schedule_url(
      token: user.calendar_token,
      format: :ics,
      host: host || request.host_with_port
    )
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
