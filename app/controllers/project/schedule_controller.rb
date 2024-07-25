class Project::ScheduleController < Project::BaseController
  layout 'project_with_sidebar', only: [:show]

  def show
    # TODO: Move query logic in the model and add tests

    # Get tasks that are due today (including past tasks here).
    @tasks_due_today = tasks.where('due_date <= ?', Date.current)

    # Get tasks that are due this week (without tasks that are today)
    @tasks_due_this_week = tasks.where(due_date: Date.current.tomorrow..Date.current.end_of_week)

    # Get tasks that are due this month (without tasks that are today and this week)
    @tasks_due_this_month = tasks.where(due_date: Date.current.end_of_week.next_day..Date.current.end_of_month)

    # Get tasks from today will end of the year
    @tasks_due_this_year = tasks.where(due_date: Date.current.end_of_month.next_day..Date.current.end_of_year)
  end

  def tasks
    project.tasks.todo.order(due_date: :asc)
  end
end
