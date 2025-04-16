class Project::ScheduleController < Project::BaseController
  def show
    @tab_name = 'Tasks'

    # TODO: Move query logic in the model and add tests
    #
    # Get tasks that are due this month (including past tasks up to today).
    @tasks_due_this_month = tasks.where(due_date: Date.current.all_month)

    # Get tasks that are due next month.
    @tasks_due_next_month = tasks.where(due_date: Date.current.next_month.all_month)

    # Get tasks that are due the month after next.
    @tasks_due_month_after_next = tasks.where(due_date: Date.current.next_month.next_month.all_month)

    # Get tasks that are past due and still active
    @tasks_past_due = @project.tasks.where("due_date < ?", Date.current).order(:due_date)
  end

  def saturate
    tasks_no_due = project.tasks.todo.no_due_date.order_by_star_then_old.limit(5)

    tasks_no_due.each do |task|
      task.update(due_date: (Date.current..Date.current.end_of_month).to_a.sample)
    end

    redirect_to project_schedule_path(@project)
  end

  private

  def tasks
    project.tasks.todo.order(due_date: :asc)
  end
end
