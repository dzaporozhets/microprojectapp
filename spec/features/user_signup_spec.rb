require 'rails_helper'

RSpec.feature "User Signup", type: :feature do
  scenario "User signs up with valid details" do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Welcome!')
    expect(page).to have_current_path(hello_path)
  end

  scenario "User signs up with invalid details" do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'wrongpassword'
    click_button 'Sign up'

    expect(page).to have_content('Password confirmation doesn\'t match')
  end

  scenario "User with allowed email domain can sign up" do
    ClimateControl.modify APP_ALLOWED_EMAIL_DOMAIN: 'company.com' do
      visit new_user_registration_path

      fill_in "Email", with: 'user123@company.com'
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"

      expect(page).to have_content("Welcome!")
    end
  end

  scenario "User with disallowed email domain cannot sign up" do
    ClimateControl.modify APP_ALLOWED_EMAIL_DOMAIN: 'company.com' do
      visit new_user_registration_path

      fill_in "Email", with: 'user123@example.com'
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"

      expect(page).to have_content("Email is not from an allowed domain.")
    end
  end

  scenario "Sign up is disabled when APP_DISABLE_SIGNUP is present" do
    ClimateControl.modify APP_DISABLE_SIGNUP: '1' do
      visit new_user_registration_path

      expect(page).to have_content('New registrations are currently disabled.')
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
