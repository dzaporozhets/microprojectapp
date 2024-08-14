require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User visit projects page" do
    visit projects_path

    expect(page).to have_text("New Project")
    expect(page).to have_content("Personal")
  end

  scenario "User visit projects page with archived projects" do
    create(:project, name: 'Old project', user: user, archived: true)

    visit projects_path

    expect(page).to have_text("New Project")
    expect(page).to have_content("Personal")
    expect(page).to have_content("Old project")
  end
end
