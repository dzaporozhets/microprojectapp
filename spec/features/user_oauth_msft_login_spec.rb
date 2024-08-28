require 'rails_helper'

RSpec.feature "User login with Microsoft", type: :feature do
  let(:user) { create(:user) }
  let(:msft_env) {
    {
      MICROSOFT_CLIENT_ID: '123',
      MICROSOFT_CLIENT_SECRET: 'abc'
    }
  }

  around do |example|
    OmniAuth.config.test_mode = true

    ClimateControl.modify(msft_env) do
      example.run
    end

    OmniAuth.config.test_mode = false
  end

  scenario "User successfully signs in with Microsoft to existing account" do
    OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
      provider: 'azure_activedirectory_v2',
      uid: '123456789',
      info: { email: user.email }
    })

    visit new_user_session_path
    click_button "Sign in with Microsoft"

    expect(page).to have_content('Projects')
    expect(page).to have_current_path(root_path)
  end

  scenario "User fails to sign in with Microsoft due to missing email" do
    OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
      provider: 'azure_activedirectory_v2',
      uid: '123456789'
    })

    visit new_user_session_path
    click_button "Sign in with Microsoft"

    expect(page).to have_content("Login with Microsoft failed")
    expect(page).to have_current_path(new_user_session_path)
  end

  scenario "User handles OmniAuth failure" do
    OmniAuth.config.mock_auth[:azure_activedirectory_v2] = :invalid_credentials

    visit new_user_session_path
    click_button "Sign in with Microsoft"

    expect(page).to have_content("Invalid credentials")
    expect(page).to have_current_path(new_user_session_path)
  end
end
