require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User creates a new project" do
    visit new_project_path

    fill_in "Name", with: "New Project"
    click_button "Create Project"

    expect(page).to have_text("New Project")
    expect(page).to have_current_path(project_path(Project.last))
  end

  scenario "User updates a project" do
    visit edit_project_path(project)

    fill_in "Name", with: "Updated Project Name"
    click_button "Update Project"

    expect(page).to have_text("Updated Project Name")
    expect(page).to have_current_path(project_path(project))
  end

  scenario "User views a project" do
    visit project_path(project)

    expect(page).to have_text(project.name)
  end

  scenario "User deletes a project from the edit page" do
    visit edit_project_path(project)

    expect { click_button "Destroy this project" }.to change(Project, :count).by(-1)
    expect(page).to have_current_path(projects_path)
  end

  scenario "Unauthorized user cannot visit the project" do
    another_user = create(:user)
    another_project = create(:project, user: another_user)

    visit project_path(another_project)

    expect(page).to have_text("The page you were looking for doesn't exist.")
  end

  scenario "Unauthorized user cannot edit project" do
    another_user = create(:user)
    another_project = create(:project, user: another_user)

    visit edit_project_path(another_project)

    expect(page).to have_text("The page you were looking for doesn't exist.")
  end
end

