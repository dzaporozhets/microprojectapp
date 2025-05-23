# spec/features/user_settings_spec.rb
require 'rails_helper'

RSpec.feature "User Settings", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit users_settings_path
  end

  scenario "User visits the settings page" do
    expect(page).to have_content("Allow other users to add you to projects")
  end

  scenario "User updates the settings" do
    check "Allow other users to add you to projects"
    click_button "Save Settings"

    expect(page).to have_content("Saved")
    expect(user.reload.allow_invites).to be_truthy
  end

  scenario "User sees validation errors" do
    allow_any_instance_of(User).to receive(:update).and_return(false)

    click_button "Save Settings"

    expect(page).to have_content("An error occurred")
  end

  scenario "User chooses dark mode" do
    choose "Dark"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html.dark'
  end

  scenario "User chooses light mode" do
    choose "Light"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html.light'
  end

  scenario "User chooses auto mode" do
    choose "Dark"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html.dark'

    choose "Auto"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html'
  end

  scenario "User uploads an avatar" do
    attach_file('user[avatar]', "#{Rails.root}/spec/fixtures/files/test_img.png")
    click_button 'Save Settings'

    expect(page).to have_content('Saved')
    expect(user.reload.avatar).to be_present
    expect(user.reload.avatar.url).to be_present
  end
end
