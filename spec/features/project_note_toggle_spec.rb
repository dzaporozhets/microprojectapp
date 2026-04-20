require 'rails_helper'

RSpec.feature 'Project::Note Toggle', type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:note) { create(:note, project: project, user: user) }

  before do
    sign_in user
  end

  scenario 'marks a note as starred' do
    visit project_note_path(project, note)
    click_link 'Star'

    expect(note.reload.star).to be(true)
  end

  scenario 'marks a note as not starred' do
    note.update(star: true)

    visit project_note_path(project, note)
    click_link 'Star'

    expect(note.reload.star).to be(false)
  end

  scenario 'starred notes appear first on project notes index' do
    starred = create(:note, project: project, user: user, title: 'Starred Note', star: true)
    newest_unstarred = create(:note, project: project, user: user, title: 'Newest Note')

    visit project_notes_path(project)

    titles = page.all('h3.list-text-primary').map(&:text)
    expect(titles.first).to eq('Starred Note')
    expect(titles).to include('Newest Note', note.title)
    expect(titles.index('Starred Note')).to be < titles.index(newest_unstarred.title)
  end

  scenario 'starred notes appear first on global notes index' do
    create(:note, project: project, user: user, title: 'Newest Note')
    create(:note, project: project, user: user, title: 'Starred Note', star: true)

    visit notes_path

    titles = page.all('h3.list-text-primary').map(&:text)
    expect(titles.first).to eq('Starred Note')
  end
end
