require 'rails_helper'

RSpec.feature "Project::Links", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:link) { create(:link, project: project, user: user) }

  before do
    sign_in user
  end

  scenario "User creates a new link" do
    visit new_project_link_path(project)

    fill_in "link_title", with: "New Link"
    fill_in "link_url", with: "http://example.com"
    click_button "Create Link"

    expect(page).to have_text("New Link")
    expect(page).to have_link("New Link", href: "http://example.com")
  end

   scenario "User creates a new link without a title" do
    visit new_project_link_path(project)

    fill_in "link_url", with: "http://example.com"
    click_button "Create Link"

    expect(page).to have_link("http://example.com", href: "http://example.com")
  end

  scenario "User views a link" do
    visit project_link_path(project, link)

    expect(page).to have_text(link.title)
    expect(page).to have_link(link.title, href: link.url)
  end

  scenario "User deletes a link" do
    visit project_files_path(project)

    within("#link_#{link.id}") do
      click_button "Delete"
    end

    expect(page).not_to have_text(link.title)
    expect(page).to have_current_path(project_files_path(project))
  end

  scenario "User visits links page" do
    visit project_links_path(project)

    expect(page).to have_current_path(project_links_path(project))
    expect(page).to have_text(link.title)
    expect(page).to have_link(link.title, href: link.url)
  end
end
