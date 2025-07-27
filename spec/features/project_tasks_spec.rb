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

  # TODO: test the same scenario with js: true
  scenario "User updates a task from the project page (no turbo)" do
    visit project_path(project)

    click_link task.name
    click_link "Edit"

    fill_in "task_name", with: "Updated Task Name"
    fill_in "task_description", with: "Updated Task Description"
    click_button "Save changes"

    expect(page).to have_text("Updated Task Name")
    expect(page).to have_text("Updated Task Description")
  end

  scenario "User deletes a task from the project page" do
    visit project_path(project)

    click_link task.name
    click_link "Edit"
    click_button "Delete"

    expect(page).to have_current_path(project_path(project))
    expect(page).not_to have_text(task.name)
  end

  scenario 'User visits tasks details' do
    visit details_project_task_path(project, task)

    expect(page).to have_content('Created by')
    expect(page).to have_content(user.email)
    expect(page).to have_content(task.name)
  end

  scenario 'User visits completed tasks page' do
    create(:task, name: 'New task', project: project, user: user, done: false)
    create(:task, name: 'Completed task', project: project, user: user, done: true)

    visit completed_project_tasks_path(project, task)

    #expect(page).to have_selector('a.btn-seg-ctl-active', text: 'Completed')
    expect(page).to have_content('Completed task')
    expect(page).not_to have_content('New task')
  end

  scenario 'User visits tasks page filtering by assigned user' do
    create(:task, name: 'Assigned task', project: project, user: user, assigned_user: user)
    create(:task, name: 'Just a task', project: project, user: user)

    visit project_tasks_path(project, task, assigned_user_id: user.id)

    expect(page).to have_content("Tasks assigned to #{user.email}")
    expect(page).to have_content('Assigned task')
    expect(page).not_to have_content('Just a task')
  end

  describe 'Task version history' do
    scenario 'User views task change history with no changes' do
      # New task with no changes yet
      new_task = create(:task, name: 'Task with no changes', project: project, user: user)

      visit changes_project_task_path(project, new_task)

      expect(page).to have_content('Task with no changes')
      expect(page).to have_content('Showing the last 5 changes to this task')
      expect(page).to have_content('No versions available')
      expect(page).to have_content('No version history found for this task')
    end

    scenario 'User views task change history with multiple changes' do
      # Create a task with PaperTrail enabled
      task_to_change = create(:task,
                              name: 'Original Task Name',
                              description: 'Original description',
                              project: project,
                              user: user)

      # Update the task to create versions
      # First update
      PaperTrail.request(whodunnit: user.id.to_s) do
        task_to_change.update(name: 'Updated Task Name')
      end

      # Second update
      PaperTrail.request(whodunnit: user.id.to_s) do
        task_to_change.update(description: 'Updated description')
      end

      visit changes_project_task_path(project, task_to_change)

      # Verify page content
      expect(page).to have_content('Updated Task Name')
      expect(page).to have_content('Showing the last 5 changes to this task')

      # Check for version information
      expect(page).to have_content('by')
      expect(page).to have_content(user.email)

      # Check for change details
      expect(page).to have_content('Name:')
      expect(page).to have_content('Original Task Name')
      expect(page).to have_content('Updated Task Name')

      expect(page).to have_content('Description:')
      expect(page).to have_content('Original description')
      expect(page).to have_content('Updated description')
    end

    scenario 'User views task change history with unknown user' do
      # Create a task with PaperTrail enabled
      task_with_unknown = create(:task,
                                 name: 'Task with unknown editor',
                                 project: project,
                                 user: user)

      # Update with non-existent user ID
      PaperTrail.request(whodunnit: '99999') do
        task_with_unknown.update(name: 'Changed by unknown')
      end

      visit changes_project_task_path(project, task_with_unknown)

      # Verify page shows "Unknown" for the user
      expect(page).to have_content('Changed by unknown')
      expect(page).to have_content('Unknown')
    end
  end
end
