require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { should belong_to(:trackable) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it "is valid with valid attributes" do
    activity = create(:activity)

    expect(activity).to be_valid
  end
end
