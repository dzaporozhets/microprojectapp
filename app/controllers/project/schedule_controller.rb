class Project::ScheduleController < Project::BaseController
  layout 'project_with_sidebar', only: [:show]

  def show
    # TODO: Move query logic in the model and add tests
    #
    # Get tasks that are due this month (including past tasks up to today).
    @tasks_due_this_month = tasks.where(due_date: Date.current.beginning_of_month..Date.current.end_of_month)

    # Get tasks that are due next month.
    @tasks_due_next_month = tasks.where(due_date: Date.current.next_month.beginning_of_month..Date.current.next_month.end_of_month)

    # Get tasks that are due the month after next.
    @tasks_due_month_after_next = tasks.where(due_date: Date.current.next_month.next_month.beginning_of_month..Date.current.next_month.next_month.end_of_month)
  end

  def tasks
    project.tasks.todo.order(due_date: :asc)
  end
end
