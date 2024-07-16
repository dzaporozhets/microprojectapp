# spec/features/password_reset_spec.rb
require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  let(:user) { create(:user) }

  scenario "User requests a password reset" do
    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Reset password"

    expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
    expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
  end

  scenario "User requests a password reset for unknown email" do
    visit new_user_password_path

    fill_in "Email", with: 'some@example.com'
    click_button "Reset password"

    expect(page).to have_content("Email not found")
  end

  scenario "User requests a password reset within throttle period" do
    user.update(reset_password_sent_at: Time.now)

    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Reset password"

    expect(page).to have_content("Password reset request already sent, please check your email.")
  end

  scenario "User requests a password reset after throttle period" do
    user.update(reset_password_sent_at: 6.minutes.ago)

    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Reset password"

    expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
    expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
  end
end
