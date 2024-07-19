require 'rails_helper'

RSpec.feature "Admin Area", type: :feature do
  let!(:admin) { create(:user, admin: true) }
  let!(:non_admin) { create(:user) }

  scenario "Admin user can access admin dashboard" do
    sign_in admin

    visit admin_path

    expect(page).to have_content('Users 2')
    expect(page).to have_content('Projects 4')
  end

  scenario "Non-admin user cannot access admin dashboard" do
    sign_in non_admin

    visit admin_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
