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
end
