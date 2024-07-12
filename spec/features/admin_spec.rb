require 'rails_helper'

RSpec.feature "AdminFeatures", type: :feature do
  let(:admin) { create(:user, admin: true) }
  let(:non_admin) { create(:user) }

  before do
    create_list(:user, 3)
  end

  scenario "Admin user can access admin dashboard" do
    sign_in admin

    visit admin_path

    expect(page).to have_content('Total Users: 4')
  end

  scenario "Non-admin user cannot access admin dashboard" do
    sign_in non_admin

    visit admin_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
