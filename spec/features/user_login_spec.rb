require 'rails_helper'

RSpec.feature "User Login", type: :feature do
  scenario "User sees Google login button when GOOGLE_CLIENT_ID is set" do
    ClimateControl.modify GOOGLE_CLIENT_ID: 'abcd1234' do
      visit new_user_session_path

      expect(page).to have_button("Sign in with Google")
      expect(page).to have_selector("form#new_user")
    end
  end

  scenario "User sees normal login form" do
    ClimateControl.modify GOOGLE_CLIENT_ID: nil do
      visit new_user_session_path

      expect(page).to have_selector("form#new_user")
      expect(page).not_to have_button("Sign in with Google")
    end
  end
end
