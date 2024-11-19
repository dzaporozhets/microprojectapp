# spec/features/archive_unarchive_project_spec.rb
require 'rails_helper'

RSpec.feature "Fav / unfav Projects", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User mark as favorite a project" do
    visit project_path(project)

    expect(page).to have_content(project.name)
    expect(page).to have_button("Mark as Favorite")

    click_button "Mark as Favorite"

    expect(page).to have_button("Unmark Favorite")
  end

  scenario "User unmark as favorite a project" do
    create(:pin, project: project, user: user)

    visit project_path(project)

    expect(page).to have_content(project.name)
    expect(page).to have_button("Unmark Favorite")

    click_button "Unmark Favorite"

    expect(page).to have_button("Mark as Favorite")
  end
end
