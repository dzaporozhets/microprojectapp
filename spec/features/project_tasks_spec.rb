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

  scenario "User updates a task from the project page" do
    visit project_path(project)

    click_link task.name

    fill_in "Name", with: "Updated Task Name"
    fill_in "Description", with: "Updated Task Description"
    click_button "Update Task"

    expect(page).to have_text("Updated Task Name")
    expect(page).to have_text("Updated Task Description")
  end

  scenario "User deletes a task from the edit page" do
    visit project_path(project)

    click_link task.name
    click_button "Delete this task"

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

