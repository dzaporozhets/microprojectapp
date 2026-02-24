require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:project) }

  it 'is valid with valid attributes' do
    project_user = build(:project_user)

    expect(project_user).to be_valid
  end
end
