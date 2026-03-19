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
