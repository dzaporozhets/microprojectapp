require 'rails_helper'

RSpec.describe Pin, type: :model do
  subject { build(:pin) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'validations' do
    # it { should validate_uniqueness_of(:user_id).scoped_to(:project_id).with_message('has already pinned this project') }
  end
end
