require 'rails_helper'

RSpec.feature "Project::Tasks", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project, user: user) }

  before do
    sign_in user
  end

  scenario "User creates a new task without a description from the project page" do
    visit project_path(project)

    fill_in "task_name", with: "Task Without Description"
    click_button "Add task"

    expect(page).to have_text("Task Without Description")
  end

  scenario "User updates the due date and assignee of a task from the edit page (no turbo)" do
    visit edit_project_task_path(project, task)

    fill_in "task_due_date", with: Time.zone.tomorrow.strftime("%Y-%m-%d")
    select user.email, from: "task_assigned_user_id"
    click_button "Save changes"

    expected_due_date = Time.zone.tomorrow.strftime("%B %d, %Y")

    expect(page).to have_text(task.name)
    expect(page).to have_text(expected_due_date)
  end

  scenario "User deletes a task from the edit page" do
    visit edit_project_task_path(project, task)

    click_button "Delete"

    expect(page).to have_current_path(project_path(project))
    expect(page).not_to have_text(task.name)
  end

  scenario "Unauthorized user cannot edit task" do
    another_user = create(:user)
    another_project = create(:project)
    another_task = create(:task, project: another_project, user: another_user)

    visit edit_project_task_path(another_project, another_task)

    expect(page).to have_text("The page you were looking for doesn't exist.")
  end
end
