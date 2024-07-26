require 'rails_helper'

RSpec.feature "Admin Area", type: :feature do
  let(:admin) { create(:user, admin: true) }
  let(:non_admin) { create(:user) }

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

  scenario "Admin can view the user page" do
    sign_in admin

    visit admin_user_path(non_admin)

    expect(page).to have_content("Account")
    expect(page).to have_content("Database")
    expect(page).to have_content(non_admin.email)
    expect(page).to have_content(non_admin.created_at)
    expect(page).to have_content(non_admin.updated_at)
  end
end
