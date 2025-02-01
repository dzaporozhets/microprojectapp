require 'rails_helper'

RSpec.feature "Admin Area", type: :feature do
  let(:admin) { create(:user, admin: true) }
  let(:non_admin) { create(:user) }
  let!(:activity) { create(:activity) }

  scenario "Admin can view the activity index page" do
    sign_in admin

    visit admin_activity_path

    expect(page).to have_content("invited")
  end

  scenario "Non-admin user cannot access admin activity page" do
    sign_in non_admin

    visit admin_activity_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
