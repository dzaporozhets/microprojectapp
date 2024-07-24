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
    click_link "Edit"

    fill_in "task_name", with: "Updated Task Name"
    fill_in "task_description", with: "Updated Task Description"
    click_button "Update"

    expect(page).to have_text("Updated Task Name")

    click_link('Updated Task Name')
    expect(page).to have_text("Updated Task Description")
  end

  scenario "User updates the due date of a task from the edit page" do
    visit project_path(project)

    click_link task.name
    click_link "Edit"

    select 'Next Month', from: 'task_due_date'
    click_button "Update"

    click_link task.name
    expect(page).to have_text(task.name)
    expect(page).to have_text((Date.today + 1.month).strftime("%B %d, %Y"))
  end

  scenario "User deletes a task from the edit page" do
    visit project_path(project)

    click_link task.name
    click_link "Edit"
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

  scenario 'User visits tasks details' do
    visit details_project_task_path(project, task)

    expect(page).to have_content('Task ID')
    expect(page).to have_content('Project ID')
    expect(page).to have_content(user.email)
    expect(page).to have_content(task.name)
  end
end

