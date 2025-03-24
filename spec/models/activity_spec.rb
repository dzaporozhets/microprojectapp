require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { is_expected.to belong_to(:trackable) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:project) }

  it "is valid with valid attributes" do
    activity = create(:activity)

    expect(activity).to be_valid
  end
end
