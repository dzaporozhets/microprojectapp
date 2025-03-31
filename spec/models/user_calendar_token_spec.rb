require 'rails_helper'

RSpec.describe User, type: :model do
  describe "calendar token" do
    let(:user) { create(:user) }

    it "generates a calendar token on creation" do
      expect(user.calendar_token).to be_present
    end

    it "generates a unique token based on email and random data" do
      user1 = create(:user, email: "user1@example.com")
      user2 = create(:user, email: "user2@example.com")

      expect(user1.calendar_token).not_to eq(user2.calendar_token)
    end

    describe "#regenerate_calendar_token!" do
      it "changes the calendar token" do
        original_token = user.calendar_token
        user.regenerate_calendar_token!

        expect(user.calendar_token).not_to eq(original_token)
      end
    end
  end
end
