class ScheduleController < ApplicationController
  before_action :authenticate_user!, except: :calendar
  before_action :authenticate_by_token, only: :calendar

  def show
    @date = user_date || Date.current

    @current_month_name = @date.strftime("%B")

    @monthly_tasks = tasks.where(due_date: @date.beginning_of_month..@date.end_of_month).order(due_date: :asc)
    @past_due_tasks = tasks.where("due_date < ?", @date.beginning_of_month).order(due_date: :asc)
    @upcoming_tasks = tasks.where(due_date: (@date.end_of_month + 1.day)..(@date + 2.months).end_of_month).order(due_date: :asc)

    @daily_task_counts = tasks.group(:due_date).count.transform_keys(&:to_date)
  end

  def calendar
    respond_to do |format|
      format.ics do
        calendar = generate_calendar
        send_data calendar.to_ical, type: 'text/calendar', disposition: 'inline', filename: "tasks-#{@user.id}.ics"
      end
    end
  end

  private

  def tasks
    Task.where(project_id: (current_user || @user).all_active_projects).todo.with_due_date.order(due_date: :asc)
  end

  def user_date
    return nil unless params[:date].present?

    begin
      Date.parse(params[:date])
    rescue Date::Error
      Date.current
    end
  end

  def authenticate_by_token
    token = params[:token]
    return head :unauthorized unless token.present?

    @user = User.find_by(calendar_token: token)
    return head :unauthorized unless @user
  end

  def generate_calendar
    require 'icalendar'
    require 'icalendar/tzinfo'

    cal = Icalendar::Calendar.new
    cal.prodid = "-//MicroProjectApp//Calendar//EN"
    cal.append_custom_property("X-WR-CALNAME", "MicroProjectApp Tasks")

    tzid = "UTC"
    tz = TZInfo::Timezone.get(tzid)
    timezone = tz.ical_timezone(Time.current)
    cal.add_timezone(timezone)

    tasks.each do |task|
      event = Icalendar::Event.new
      event.dtstart = Icalendar::Values::Date.new(task.due_date)
      event.dtend = Icalendar::Values::Date.new(task.due_date)
      event.summary = task.name
      event.description = task.description if task.description.present?
      event.uid = "task-#{task.id}@microprojectapp"
      event.url = Rails.application.routes.url_helpers.project_task_url(task.project, task, host: request.host)

      # Add project name to location
      event.location = task.project.name if task.project.present?

      cal.add_event(event)
    end

    cal
  end
end
