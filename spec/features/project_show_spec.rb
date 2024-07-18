require 'rails_helper'

RSpec.feature "Project", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User views a project" do
    visit project_path(project)

    expect(page).to have_text(project.name)
  end

  scenario "Unauthorized user cannot visit the project" do
    another_user = create(:user)
    another_project = create(:project, user: another_user)

    visit project_path(another_project)

    expect(page).to have_text("The page you were looking for doesn't exist.")
  end
end

