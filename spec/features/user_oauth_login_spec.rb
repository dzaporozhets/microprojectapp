require 'rails_helper'

RSpec.feature "User login with Google", type: :feature do
  let(:user) { create(:user) }
  let(:google_env) {
    {
      GOOGLE_CLIENT_ID: '123',
      GOOGLE_CLIENT_SECRET: 'abc'
    }
  }

  around do |example|
    OmniAuth.config.test_mode = true

    ClimateControl.modify(google_env) do
      example.run
    end

    OmniAuth.config.test_mode = false
  end

  scenario "User successfully signs in with Google to existing account" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: { email: user.email }
    })

    visit new_user_session_path
    click_button "Sign in with Google"

    expect(page).to have_content('Projects')
    expect(page).to have_current_path(root_path)
  end

  scenario "User fails to sign in with Google due to missing email" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789'
    })

    visit new_user_session_path
    click_button "Sign in with Google"

    expect(page).to have_content("Login with Google failed")
    expect(page).to have_current_path(new_user_session_path)
  end

  scenario "User handles OmniAuth failure" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    visit new_user_session_path
    click_button "Sign in with Google"

    expect(page).to have_content("Could not authenticate you from GoogleOauth2 because \"Invalid credentials\".")
    expect(page).to have_current_path(new_user_session_path)
  end
end

