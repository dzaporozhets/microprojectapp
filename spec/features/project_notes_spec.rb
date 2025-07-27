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
  end

  scenario "User views a note" do
    visit project_note_path(project, note)

    expect(page).to have_text(note.title)
    expect(page).to have_text(note.content)
  end

  scenario "User edits a note" do
    visit edit_project_note_path(project, note)

    fill_in 'note_title', with: '123'
    fill_in 'note_content', with: '456'

    click_button 'Save Changes'

    note.reload

    expect(note.title).to eq('123')
    expect(note.content).to eq('456')
  end

  scenario "User deletes a note" do
    visit history_project_note_path(project, note)

    expect(page).to have_text(note.title)

    click_button "Delete this note"

    expect(page).not_to have_text(note.title)
    expect(page).to have_current_path(overview_project_path(project))
  end
end
