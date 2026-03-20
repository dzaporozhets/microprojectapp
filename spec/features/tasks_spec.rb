require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { create(:user) }

  let!(:project1) { create(:project, user: user) }
  let!(:project2) { create(:project) }
  let!(:project3) { create(:project) } # User is not involved with this project
  let!(:task1) { create(:task, project: project1) }
  let!(:task2) { create(:task, project: project2) }
  let!(:task3) { create(:task, project: project3) } # Task from a project user is not part of

  before do
    project2.users << user

    sign_in user
  end

  scenario "user views the tasks list" do
    visit tasks_path

    expect(page).to have_content(task1.name)
    expect(page).to have_content(task2.name)
    expect(page).not_to have_content(task3.name) # Task from project user is not involved with should not be shown
  end

  context "tasks page sections" do
    let!(:overdue_task) { create(:task, project: project1, name: "Overdue chore", due_date: Date.current - 3.days) }
    let!(:today_task) { create(:task, project: project1, name: "Today chore", due_date: Date.current) }
    let!(:assigned_task) { create(:task, project: project1, name: "Assigned chore", assigned_user: user) }

    scenario "user sees due-soon and assigned-to-you sections" do
      visit tasks_path

      expect(page).to have_content("Due soon")
      expect(page).to have_content(overdue_task.name)
      expect(page).to have_content(today_task.name)

      expect(page).to have_content("Assigned to you")
      expect(page).to have_content(assigned_task.name)

      expect(page).to have_content(task1.name)
    end
  end

  context "creating a task from tasks index" do
    scenario "user creates a task via the new task page" do
      visit tasks_path

      click_link "New Task"

      expect(page).to have_current_path(new_task_path)
      expect(page).to have_content("New task")

      select project1.name, from: "Project"
      fill_in "Name", with: "My new task"
      click_button "Create task"

      expect(page).to have_current_path(tasks_path)
      expect(page).to have_content("Task was successfully created.")
      expect(page).to have_content("My new task")
    end
  end

  scenario "/schedule redirects to /tasks" do
    visit "/schedule"

    expect(page).to have_current_path(tasks_path)
  end
end
