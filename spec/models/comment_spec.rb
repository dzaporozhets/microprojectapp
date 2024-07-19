require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:task) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  it 'has a valid factory' do
    expect(create(:comment)).to be_valid
  end

  it 'displays the correct user email' do
    user = create(:user)
    comment = create(:comment, user: user)
    expect(comment.user_email).to eq(user.email)
  end
end
