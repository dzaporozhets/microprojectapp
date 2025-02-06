require 'rails_helper'

RSpec.feature "User Edit", type: :feature do
  context "when user logs in with Google" do
    let(:google_user) { create(:user, uid: "12345", provider: "google_oauth2") }

    scenario "redirect to account page and show the error message" do
      sign_in google_user
      visit edit_user_registration_path

      expect(page).to have_content("Not allowed for OAuth user.")
      expect(page).to have_current_path(users_account_path)
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

      expect(page).to have_content("You updated your account successfully")
    end
  end
end
