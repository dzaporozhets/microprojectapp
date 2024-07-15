require 'rails_helper'

RSpec.feature "Admin Area", type: :feature do
  let(:admin) { create(:user, admin: true) }
  let(:non_admin) { create(:user) }

  before do
    create_list(:user, 3)
  end

  scenario "Admin user can access admin dashboard" do
    sign_in admin

    visit admin_path

    expect(page).to have_content('Users 4')
    expect(page).to have_content('Projects 8')
  end

  scenario "Non-admin user cannot access admin dashboard" do
    sign_in non_admin

    visit admin_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

   scenario "Admin can view the users index page" do
    sign_in admin

    visit admin_users_path

    expect(page).to have_content("Users")
    expect(page).to have_css("table")
  end

  scenario "Non-admin user cannot access admin users page" do
    sign_in non_admin

    visit admin_users_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
