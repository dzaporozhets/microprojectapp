require 'rails_helper'

RSpec.feature "Activity", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:invitee) { create(:user) }

  before do
    sign_in user
  end

  scenario "User creates a task and it appears on activity page" do
    visit project_path(project)

    fill_in "task_name", with: "New Task"
    click_button "Add task"

    visit project_activity_path(project)

    expect(page).to have_content('created the task')
  end

  scenario "User deletes a task and it appears on activity page" do
    task = create(:task, project: project, user: user)

    visit project_path(project)

    click_link task.name
    click_link "Edit"
    click_button "Delete"

    visit project_activity_path(project)

    expect(page).to have_content('removed the task')
  end

  scenario "User invites another user to the project and it appears on the activity page" do
    visit invite_project_users_path(project)

    fill_in "Email", with: invitee.email
    click_button "Add user"

    visit project_activity_path(project)

    expect(page).to have_content("invited #{invitee.email}")

    invitee.destroy!

    visit project_activity_path(project)

    expect(page).to have_content("invited (removed)")
  end
end

