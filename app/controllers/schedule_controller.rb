class ScheduleController < ApplicationController
  before_action :authenticate_user!, except: :calendar
  before_action :authenticate_by_token, only: :calendar

  def show
    @tasks = tasks.order(due_date: :asc).page(params[:page]).per(20)
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
    Task.todo.where(project_id: (current_user || @user).all_active_projects).with_due_date.order(due_date: :asc)
  end

  def authenticate_by_token
    token = params[:token]
    return head :unauthorized if token.blank?

    @user = User.find_by(calendar_token: token)
    head :unauthorized unless @user
  end
end
