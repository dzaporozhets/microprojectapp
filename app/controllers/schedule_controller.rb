class ScheduleController < ApplicationController
  before_action :authenticate_user!, except: :calendar
  before_action :authenticate_by_token, only: :calendar

  def show
    @date = user_date || Date.current

    @current_month_name = @date.strftime("%B")

    @monthly_tasks = tasks.where(due_date: @date.all_month).order(due_date: :asc)
    @past_due_tasks = tasks.where(due_date: ...@date.beginning_of_month).order(due_date: :asc)
    @upcoming_tasks = tasks.where(due_date: (@date.end_of_month + 1.day)..(@date + 2.months).end_of_month).order(due_date: :asc)

    @daily_task_counts = tasks.group(:due_date).count.transform_keys(&:to_date)
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
    Task.where(project_id: (current_user || @user).all_active_projects).todo.with_due_date.order(due_date: :asc)
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
