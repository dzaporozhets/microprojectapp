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

  scenario 'User login with email and password' do
    user = create(:user)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_current_path(root_path)
  end

  scenario 'User has 2fa enabled' do
    user = create(:user)
    user.update(otp_required_for_login: true)
    allow_any_instance_of(User).to receive(:validate_and_consume_otp!).and_return(true)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content('Two Factor Authentication')

    fill_in 'user_otp_attempt', with: '123456'
    click_button 'Login'

    expect(page).to have_current_path(root_path)
  end
end
