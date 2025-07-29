require "rails_helper"

RSpec.feature "Schedule", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  let!(:current_month_task) { create(:task, name: "Current Month Task", project: project, due_date: Date.current + 15.days, done: false) }
  let!(:next_month_task) { create(:task, name: "Next Month Task", project: project, due_date: Date.current + 1.month + 10.days, done: false) }

  before { sign_in user }

  scenario "shows three month calendars with tasks" do
    visit schedule_path(date: Date.current.strftime("%Y-%m-01"))

    # Check that three months are displayed
    current_month = Date.current.strftime("%B")
    next_month = Date.current.next_month.strftime("%B")
    month_after_next = Date.current.next_month.next_month.strftime("%B")
    
    expect(page).to have_content(current_month)
    expect(page).to have_content(next_month)
    expect(page).to have_content(month_after_next)

    # Check that tasks are displayed in their respective months
    expect(page).to have_content("Current Month Task")
    expect(page).to have_content("Next Month Task")

    # Check that calendar legend is present (only the ones we kept)
    expect(page).to have_content("Today")
    expect(page).to have_content("Has Tasks")

    # Check that navigation arrows are present
    expect(page).to have_selector(".prev-month")
    expect(page).to have_selector(".next-month")
  end

  scenario "shows empty state when no tasks exist" do
    Task.delete_all
    visit schedule_path(date: Date.current.strftime("%Y-%m-01"))

    # Should still show three months but with no tasks
    current_month = Date.current.strftime("%B")
    next_month = Date.current.next_month.strftime("%B")
    month_after_next = Date.current.next_month.next_month.strftime("%B")
    
    expect(page).to have_content(current_month)
    expect(page).to have_content(next_month)
    expect(page).to have_content(month_after_next)
    expect(page).to have_content("No tasks due this month")
  end

  scenario "navigates between months using arrows" do
    visit schedule_path(date: Date.current.strftime("%Y-%m-01"))

    # Click next month arrow
    find(".next-month").click
    expect(page).to have_current_path(schedule_path(date: Date.current.next_month.strftime("%Y-%m-01")))

    # Click previous month arrow
    find(".prev-month").click
    expect(page).to have_current_path(schedule_path(date: Date.current.strftime("%Y-%m-01")))
  end
end
