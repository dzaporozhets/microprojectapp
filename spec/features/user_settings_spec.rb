# spec/features/user_settings_spec.rb
require 'rails_helper'

RSpec.feature "User Settings", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  scenario "User visits the settings page" do
    visit users_settings_path

    expect(page).to have_content("Allow other users to add you to projects")
  end

  scenario "User updates the settings" do
    visit users_settings_path
    check "Allow other users to add you to projects"
    click_button "Save Settings"

    expect(page).to have_content("Saved")
    expect(user.reload.allow_invites).to be_truthy
  end

  scenario "User sees validation errors" do
    allow_any_instance_of(User).to receive(:update).and_return(false)
    visit users_settings_path

    click_button "Save Settings"

    expect(page).to have_content("An error occurred")
  end

  scenario "User chooses dark mode" do
    visit users_settings_path
    choose "Dark"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html.dark'
  end

  scenario "User chooses light mode" do
    visit users_settings_path
    choose "Light"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html.light'
  end

  scenario "User chooses auto mode" do
    visit users_settings_path
    choose "Dark"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html.dark'

    choose "Auto"

    click_button "Save Settings"

    expect(page).to have_selector :css, 'html'
  end

  context "when file storage is enabled" do
    before do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        Rails.application.config.app_settings.merge(enable_local_file_storage: true)
      )
    end

    scenario "User sees avatar upload field" do
      visit users_settings_path

      expect(page).to have_field('user[avatar]')
    end

    scenario "User uploads an avatar" do
      visit users_settings_path
      attach_file('user[avatar]', "#{Rails.root}/spec/fixtures/files/test_img.png")
      click_button 'Save Settings'

      expect(page).to have_content('Saved')
      expect(user.reload.avatar).to be_present
      expect(user.reload.avatar.url).to be_present
    end
  end

  context "when file storage is disabled" do
    before do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        Rails.application.config.app_settings.merge(
          aws_s3_bucket: nil,
          enable_local_file_storage: false
        )
      )
    end

    scenario "Avatar upload field is hidden" do
      visit users_settings_path

      expect(page).not_to have_field('user[avatar]')
    end
  end
end
