require 'rails_helper'

RSpec.feature "User Edit", type: :feature do
  context "when user logs in with Google" do
    let(:google_user) { create(:user, uid: "12345", provider: "google_oauth2") }

    scenario "shows Google login message and disables email field" do
      sign_in google_user
      visit edit_user_registration_path

      expect(page).to have_content("You logged in with Google with this email.")
      expect(page).to have_field("Email", disabled: true)
    end
  end

  context "when user does not log in with Google" do
    let(:user) { create(:user) }
    let(:new_email) { user.email + ".changed" }

    scenario "allows email update" do
      sign_in user
      visit edit_user_registration_path

      fill_in "Email", with: new_email
      fill_in "Current password", with: user.password
      click_button "Save Changes"

      expect(user.reload.email).to eq(new_email)
      expect(page).to have_content("Your account has been updated successfully.")
    end
  end
end
