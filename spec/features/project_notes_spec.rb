require 'rails_helper'

RSpec.feature "Project::Notes", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:note) { create(:note, project: project, user: user) }

  before do
    sign_in user
  end

  scenario "User creates a new note and redirects to edit page" do
    visit new_project_note_path(project)

    last_doc = project.notes.last

    expect(page).to have_current_path(edit_project_note_path(project, last_doc))
    #expect(page).to have_link('Read view', href: project_note_path(project, last_doc))
  end

  scenario "User views a note" do
    visit project_note_path(project, note)

    expect(page).to have_text(note.title)
    expect(page).to have_text(note.content)
    expect(page).to have_link('Edit', href: edit_project_note_path(project, note))
  end

  scenario "User deletes a note" do
    visit project_files_path(project)

    expect(page).to have_text(note.title)

    within("#note_#{note.id}") do
      click_button "Delete"
    end

    expect(page).not_to have_text(note.title)
    expect(page).to have_current_path(project_files_path(project))
  end
end
