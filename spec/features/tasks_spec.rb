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
    let!(:starred_task) { create(:task, project: project1, name: "Starred chore", star: true) }

    scenario "user sees due-date, starred, and project sections" do
      visit tasks_path

      expect(page).to have_content("Due dates")
      expect(page).to have_content(overdue_task.name)
      expect(page).to have_content(today_task.name)

      expect(page).to have_content("Starred")
      expect(page).to have_content(starred_task.name)

      # Regular tasks still appear in project-grouped section
      expect(page).to have_content(task1.name)
    end
  end

  scenario "/schedule redirects to /tasks" do
    visit "/schedule"

    expect(page).to have_current_path(tasks_path)
  end
end
