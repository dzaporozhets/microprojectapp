require 'rails_helper'

RSpec.feature "Project", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User updates a project" do
    visit edit_project_path(project)

    fill_in "project_name", with: "Updated Project Name"
    click_button "Save Changes"

    expect(page).to have_text("Updated Project Name")
    expect(page).to have_text("Project was successfully updated")
    expect(page).to have_current_path(edit_project_path(project))
  end

  scenario "User deletes a project from the edit page" do
    visit edit_project_path(project)

    expect { click_button "Delete this project" }.to change(Project, :count).by(-1)
    expect(page).to have_current_path(projects_path)
  end

  scenario "User saves a description and sees it on the project home page" do
    visit edit_project_path(project)

    fill_in "project_description", with: "Check out this link: https://example.com\nAnd some notes below."
    click_button "Save Changes"

    visit project_path(project)

    expect(page).to have_link("https://example.com", href: "https://example.com")
    expect(page).to have_text("And some notes below.")
  end

  scenario "User clears the description and it no longer appears on the project home page" do
    project.update!(description: "Temporary description")

    visit edit_project_path(project)

    fill_in "project_description", with: ""
    click_button "Save Changes"

    visit project_path(project)

    expect(page).not_to have_text("Temporary description")
  end

  scenario "Unauthorized user cannot edit project" do
    another_user = create(:user)
    another_project = create(:project, user: another_user)

    visit edit_project_path(another_project)

    expect(page).to have_text("The page you were looking for doesn't exist.")
  end
end
