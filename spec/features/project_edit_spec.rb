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

  scenario "Unauthorized user cannot edit project" do
    another_user = create(:user)
    another_project = create(:project, user: another_user)

    visit edit_project_path(another_project)

    expect(page).to have_text("The page you were looking for doesn't exist.")
  end
end
