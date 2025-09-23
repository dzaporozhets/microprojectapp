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

  scenario "User archives a pinned project and it gets removed from favourites" do
    # First pin the project
    create(:pin, project: project, user: user)
    expect(user.pinned_projects).to include(project)

    # Then archive it
    visit edit_project_path(project)
    click_button "Archive Project"

    # Verify project is archived and no longer pinned
    expect(project.reload.archived).to be true
    expect(user.reload.pinned_projects).not_to include(project)
  end
end
