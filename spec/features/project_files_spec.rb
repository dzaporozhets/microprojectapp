require 'rails_helper'

RSpec.feature "Project::Files", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:project_with_files) { create(:project, :with_files, user: user) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User uploads a file" do
    visit new_project_file_path(project)

    attach_file('project[project_files][]', "#{Rails.root}/spec/fixtures/files/test_file.txt")
    click_button 'Upload'

    expect(page).to have_content('test_file.txt')
    expect(project.reload.project_files).to be_present
  end

  scenario "User downloads a file" do
    visit project_files_path(project_with_files)

    click_link 'test_file.txt', href: download_project_files_path(project_with_files, file: project_with_files.project_files[0].identifier)

    expect(page.response_headers['Content-Disposition']).to include('attachment; filename="test_file.txt"')
  end

  scenario "User deletes a file" do
    visit project_files_path(project_with_files)

    find("button[alt='Delete file']").click

    expect(page).not_to have_content('test_file.txt')
    expect(project_with_files.reload.project_files).to be_empty
  end

  scenario "User visits files page" do
    visit project_files_path(project_with_files)

    expect(page).to have_current_path(overview_project_path(project_with_files))
    expect(page).to have_text('test_file.txt')
  end
end
