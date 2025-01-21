require 'rails_helper'

RSpec.feature "Project::Documents", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:document) { create(:document, project: project, user: user) }

  before do
    sign_in user
  end

  scenario "User creates a new document and redirects to edit page" do
    visit new_project_document_path(project)

    last_doc = project.documents.last

    expect(page).to have_current_path(edit_project_document_path(project, last_doc))
    #expect(page).to have_link('Read view', href: project_document_path(project, last_doc))
  end

  scenario "User views a document" do
    visit project_document_path(project, document)

    expect(page).to have_text(document.title)
    expect(page).to have_text(document.content)
    expect(page).to have_link('Edit', href: edit_project_document_path(project, document))
  end

  scenario "User deletes a document" do
    visit project_files_path(project)

    expect(page).to have_text(document.title)

    within("#document_#{document.id}") do
      click_button "Delete"
    end

    expect(page).not_to have_text(document.title)
    expect(page).to have_current_path(project_files_path(project))
  end
end
