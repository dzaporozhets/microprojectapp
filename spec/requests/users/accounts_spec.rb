require 'rails_helper'

RSpec.describe "Users::Accounts", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "POST /users/account/regenerate_calendar_token" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "regenerates the user's calendar token" do
      original_token = user.calendar_token

      post regenerate_calendar_token_users_account_path

      expect(response).to redirect_to(users_account_path)
      expect(flash[:notice]).to include("Calendar token has been regenerated")

      # Reload user to get the updated token
      user.reload
      expect(user.calendar_token).not_to eq(original_token)
    end
  end
end
