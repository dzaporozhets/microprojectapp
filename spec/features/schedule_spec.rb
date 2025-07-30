require "rails_helper"

RSpec.feature "Schedule", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  let!(:task1) { create(:task, name: "First Task", project: project, due_date: Date.current + 5.days, done: false) }
  let!(:task2) { create(:task, name: "Second Task", project: project, due_date: Date.current + 10.days, done: false) }

  before { sign_in user }

  scenario "shows upcoming tasks ordered by due date" do
    visit schedule_path

    # Check that tasks are displayed
    expect(page).to have_content("First Task")
    expect(page).to have_content("Second Task")
  end

  scenario "shows empty state when no tasks exist" do
    Task.delete_all
    visit schedule_path

    expect(page).to have_content("No upcoming tasks")
  end

  scenario "shows pagination when there are many tasks" do
    # Delete existing tasks first to have a clean slate
    Task.delete_all
    
    # Create more than 20 tasks to trigger pagination
    25.times do |i|
      create(:task, name: "Task #{i}", project: project, due_date: Date.current + i.days, done: false)
    end

    visit schedule_path

    expect(page).to have_content("Task 0")
    expect(page).to have_content("Task 19")
    expect(page).not_to have_content("Task 20") # Should be on next page
    
    # Check that pagination is present
    expect(page).to have_content("1")
    expect(page).to have_content("2")
    expect(page).to have_content("Next ›")
  end
end
