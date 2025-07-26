class ScheduleController < ApplicationController
  before_action :authenticate_user!, except: :calendar
  before_action :authenticate_by_token, only: :calendar

  def show
    @date = user_date || Date.current

    # Fetch tasks for current and next months for the calendar view
    current_month_start = @date.beginning_of_month
    next_month_end = @date.next_month.end_of_month

    @monthly_tasks = tasks.where(due_date: current_month_start..next_month_end).order(due_date: :asc)

    # Load task counts for previous, current, and next months including full weeks
    prev_month_start = @date.prev_month.beginning_of_month.beginning_of_week(:monday)
    next_month_end = @date.next_month.end_of_month.end_of_week(:monday)

    @daily_task_counts = tasks.where(due_date: prev_month_start..next_month_end)
                              .group(:due_date)
                              .count
                              .transform_keys(&:to_date)
  end

  def calendar
    respond_to do |format|
      format.ics do
        calendar = CalendarTaskExporter.new(
          tasks: tasks,
          host: request.host
        ).to_ical

        send_data calendar.to_ical,
                  type: 'text/calendar',
                  disposition: 'inline',
                  filename: "tasks-#{@user.id}.ics"
      end
    end
  end

  private

  def tasks
    Task.where(project_id: (current_user || @user).all_active_projects).with_due_date.order(due_date: :asc)
  end

  def user_date
    return nil if params[:date].blank?

    begin
      Date.parse(params[:date])
    rescue Date::Error
      Date.current
    end
  end

  def authenticate_by_token
    token = params[:token]
    return head :unauthorized if token.blank?

    @user = User.find_by(calendar_token: token)
    head :unauthorized unless @user
  end
end
