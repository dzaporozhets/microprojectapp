require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  let(:user) { create(:user) }
  let(:error_message) { 'If your email address exists in our database, you will receive a password recovery link'.freeze }

  before do
    ActionMailer::Base.deliveries = []
  end

  scenario "User requests a password reset" do
    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Reset password"

    expect(page).to have_content(error_message)
    expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
  end

  scenario "User requests a password reset for unknown email" do
    visit new_user_password_path

    fill_in "Email", with: 'some@example.com'
    click_button "Reset password"

    # In paranoid mode, the message should be the same as for a known email
    expect(page).to have_content(error_message)
  end

  scenario "User requests a password reset within throttle period" do
    user.update(reset_password_sent_at: Time.now)

    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Reset password"

    # The message remains the same due to paranoid mode
    expect(page).to have_content(error_message)

    # Ensure no new email is sent
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  scenario "User requests a password reset after throttle period" do
    user.update(reset_password_sent_at: 6.minutes.ago)

    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Reset password"

    expect(page).to have_content(error_message)
    expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
  end
end
