require 'rails_helper'

RSpec.describe Note, type: :model do
  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }

  describe 'content' do
    it 'is optional' do
      note = build(:note, content: nil)
      expect(note).to be_valid
    end
  end

  describe 'version history' do
    it 'tracks content changes' do
      note = create(:note, content: "Original")
      note.update(content: "Updated")
      expect(note.versions.count).to eq(1)
    end

    it 'does not track title changes' do
      note = create(:note, title: "Original")
      note.update(title: "Updated")
      expect(note.versions.count).to eq(0)
    end

  end

  describe '.basic_order' do
    it 'returns starred notes before unstarred notes' do
      project = create(:project)
      older_starred = create(:note, project: project, star: true)
      newer_unstarred = create(:note, project: project, star: false)

      expect(Note.basic_order).to eq([older_starred, newer_unstarred])
    end

    it 'orders notes of the same star status by id descending' do
      project = create(:project)
      older = create(:note, project: project, star: false)
      newer = create(:note, project: project, star: false)

      expect(Note.basic_order).to eq([newer, older])
    end
  end

  describe 'attachment' do
    it 'rejects files over 5MB' do
      note = create(:note)
      blob = ActiveStorage::Blob.create_and_upload!(
        io: StringIO.new('x' * (5.megabytes + 1)),
        filename: 'large.bin',
        content_type: 'application/octet-stream'
      )
      note.attachment.attach(blob)

      expect(note).not_to be_valid
      expect(note.errors[:attachment]).to include('is too large (max 5MB)')
    end
  end
end
