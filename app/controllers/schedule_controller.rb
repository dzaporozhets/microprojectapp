class ScheduleController < ApplicationController
  def show
    @date = user_date || Date.current

    @current_month_name = @date.strftime("%B")

    # Get tasks that are due this month (including past tasks up to today).
    @tasks_due_this_month = tasks.where(due_date: @date.beginning_of_month..@date.end_of_month).page(params[:page]).per(200)
  end

  private

  def tasks
    Task.where(project_id: current_user.all_active_projects).todo.order(due_date: :asc)
  end

  def user_date
    return nil unless params[:date].present?

    begin
      Date.parse(params[:date])
    rescue Date::Error
      Date.current
    end
  end
end
