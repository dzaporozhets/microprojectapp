require "rails_helper"

RSpec.feature "Schedule", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  let!(:current_month_task) { create(:task, name: "Current Month Task", project: project, due_date: Date.new(2025, 3, 15)) }
  let!(:next_month_task) { create(:task, name: "Next Month Task", project: project, due_date: Date.new(2025, 4, 10)) }

  before { sign_in user }

  scenario "shows current and next month calendars with tasks" do
    visit schedule_path(date: "2025-03-01")

    # Check that both months are displayed
    expect(page).to have_content("March 2025")
    expect(page).to have_content("April 2025")

    # Check that tasks are displayed in their respective months
    expect(page).to have_content("Current Month Task")
    expect(page).to have_content("Next Month Task")

    # Check that calendar legend is present
    expect(page).to have_content("Selected & Today")
    expect(page).to have_content("Selected Date")
    expect(page).to have_content("Today")
    expect(page).to have_content("Has Tasks")

    # Check that navigation arrows are present
    expect(page).to have_selector(".prev-month")
    expect(page).to have_selector(".next-month")
  end

  scenario "shows empty state when no tasks exist" do
    Task.delete_all
    visit schedule_path(date: "2025-03-01")

    # Should still show both months but with no tasks
    expect(page).to have_content("March 2025")
    expect(page).to have_content("April 2025")
    expect(page).to have_content("No tasks scheduled")
  end

  scenario "navigates between months using arrows" do
    visit schedule_path(date: "2025-03-01")

    # Click next month arrow
    find(".next-month").click
    expect(page).to have_current_path(schedule_path(date: "2025-04-01"))

    # Click previous month arrow
    find(".prev-month").click
    expect(page).to have_current_path(schedule_path(date: "2025-03-01"))
  end
end
