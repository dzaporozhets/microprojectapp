require 'rails_helper'

RSpec.feature "User Lockable", type: :feature do
  let(:user) { create(:user) }

  before do
    user.update(locked_at: nil, failed_attempts: 0)
  end

  scenario "locks an account after too many failed login attempts" do
    visit new_user_session_path

    Devise.maximum_attempts.times do
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"
    end

    expect(page).to have_content("Your account is locked.")
  end

  scenario "unlocks an account after the unlock period" do
    user.update(locked_at: Time.current - 2.hours)

    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content("Log out")
    expect(page).to have_current_path(root_path)
  end

  scenario "warns on the last attempt before account is locked" do
    visit new_user_session_path

    (Devise.maximum_attempts - 1).times do
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"
    end

    expect(page).to have_content("You have one more attempt before your account is locked.")
  end
end

