require 'rails_helper'

RSpec.feature "Project", type: :feature do
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
end
