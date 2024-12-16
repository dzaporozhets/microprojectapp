# spec/features/archive_unarchive_project_spec.rb
require 'rails_helper'

RSpec.feature "Archive and Unarchive Projects", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User archives a project" do
    visit edit_project_path(project)

    expect(page).to have_content(project.name)
    expect(page).to have_button("Archive")

    click_button "Archive"

    expect(page).to have_button("Unarchive")
    expect(project.reload.archived).to be true
  end

  scenario "User unarchives a project" do
    project.update(archived: true)
    visit edit_project_path(project)

    expect(page).to have_content(project.name)
    expect(page).to have_button("Unarchive")

    click_button "Unarchive"

    expect(page).to have_button("Archive")
    expect(project.reload.archived).to be false
  end
end
