require 'rails_helper'

RSpec.feature "Project::Users", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:non_invited_user) { create(:user, allow_invites: false) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
    project.users << invited_user # Ensure the invited user is added to the project for remove tests
  end

  scenario "User invites a new member to the project" do
    visit project_users_path(project)

    click_link "Invite people"
    fill_in "User Email", with: user2.email
    click_button "Add user"

    expect(page).to have_text(user2.email)
    expect(page).to have_current_path(project_users_path(project))
  end

  scenario "User cant invite a new member to the someone elses project" do
    sign_in invited_user
    visit project_users_path(project)

    expect(page).not_to have_link('Invite people')
  end

  scenario "User attempts to invite a non-existing user" do
    visit project_users_path(project)

    click_link "Invite people"
    fill_in "User Email", with: "nonexistent@example.com"
    click_button "Add user"

    expect(page).to have_current_path(invite_project_users_path(project))
    expect(page).to have_text("User not found")
  end

  scenario "User attempts to invite a user who has disabled invitations" do
    visit project_users_path(project)

    click_link "Invite people"
    fill_in "User Email", with: non_invited_user.email
    click_button "Add user"

    expect(page).to have_current_path(invite_project_users_path(project))
    expect(page).to have_text("User disabled invitations")
  end

  scenario "User removes a member from the project" do
    visit project_users_path(project)

    expect(page).to have_text(invited_user.email)

    within("#project_user_#{invited_user.id}") do
      click_button "Remove"
    end

    expect(page).not_to have_text(invited_user.email)
  end

  scenario "User attempts to invite an existing project member" do
    visit project_users_path(project)

    click_link "Invite people"
    fill_in "User Email", with: invited_user.email
    click_button "Add user"

    expect(page).to have_current_path(invite_project_users_path(project))
    expect(page).to have_text("User is already added to the project")
  end
end
