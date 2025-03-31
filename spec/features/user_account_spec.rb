# spec/features/user_account_spec.rb
require 'rails_helper'

RSpec.feature "User Account", type: :feature do
  let(:user) { create(:user, email: 'original@example.com') }

  before do
    sign_in user
  end

  scenario "User visits the account page" do
    visit users_account_path

    expect(page).to have_content("Delete my account")
    expect(page).to have_button("Delete my account")
  end

  scenario "User sees calendar token regeneration option" do
    visit users_account_path

    expect(page).to have_content("Calendar Integration")
    expect(page).to have_content("Calendar Token")
    expect(page).to have_content("Your calendar token allows you to subscribe to your tasks")
    expect(page).to have_link("Regenerate Calendar Token")
  end

  # We'll skip the delete account test in feature specs since it requires JS confirmation
  # This is better tested in the controller spec where we can directly test the action

  context "when user is authenticated via OAuth" do
    let(:oauth_user) { create(:user, provider: 'google_oauth2', uid: '123456') }

    before do
      sign_out user
      sign_in oauth_user
    end

    scenario "OAuth user sees their provider information" do
      visit users_account_path

      expect(page).to have_content("Connected via OAuth")
      expect(page).to have_content("Google")
      expect(page).to have_content(oauth_user.email)
    end
  end
end
