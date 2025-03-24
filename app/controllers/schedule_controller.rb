class ScheduleController < ApplicationController
  def show
    @date = user_date || Date.current

    @current_month_name = @date.strftime("%B")

    @monthly_tasks = tasks.where(due_date: @date.beginning_of_month..@date.end_of_month).order(due_date: :asc)
    @past_due_tasks = tasks.where("due_date < ?", @date.beginning_of_month).order(due_date: :asc)
    @upcoming_tasks = tasks.where(due_date: (@date.end_of_month + 1.day)..(@date + 2.months).end_of_month).order(due_date: :asc)

    @daily_task_counts = tasks.group(:due_date).count.transform_keys(&:to_date)
  end

  private

  def tasks
    Task.where(project_id: current_user.all_active_projects).todo.with_due_date.order(due_date: :asc)
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
