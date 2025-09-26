require 'rails_helper'

RSpec.describe "Admin Access Security", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:regular_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  let(:target_user) { create(:user) }

  describe "Admin dashboard access" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "allows access to admin dashboard" do
        get admin_path
        expect(response).to have_http_status(:ok)
      end

      it "allows access to admin activity page" do
        get admin_activity_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "denies access to admin dashboard" do
        get admin_path
        expect(response).to have_http_status(:not_found)
      end

      it "denies access to admin activity page" do
        get admin_activity_path
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in for admin dashboard" do
        get admin_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in for admin activity" do
        get admin_activity_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "Admin user management access" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "allows viewing users list" do
        get admin_users_path
        expect(response).to have_http_status(:ok)
      end

      it "allows viewing user details" do
        get admin_user_path(target_user)
        expect(response).to have_http_status(:ok)
      end

      it "allows accessing user edit page" do
        get edit_admin_user_path(target_user)
        expect(response).to have_http_status(:ok)
      end

      it "allows updating users" do
        patch admin_user_path(target_user), params: { user: { admin: true } }
        expect(response).to have_http_status(:found) # redirect after update
      end

      it "allows deleting users" do
        delete admin_user_path(target_user)
        expect(response).to have_http_status(:found) # redirect after delete
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "denies viewing users list" do
        get admin_users_path
        expect(response).to have_http_status(:not_found)
      end

      it "denies viewing user details" do
        get admin_user_path(target_user)
        expect(response).to have_http_status(:not_found)
      end

      it "denies accessing user edit page" do
        get edit_admin_user_path(target_user)
        expect(response).to have_http_status(:not_found)
      end

      it "denies updating users" do
        patch admin_user_path(target_user), params: { user: { admin: true } }
        expect(response).to have_http_status(:not_found)
      end

      it "denies deleting users" do
        delete admin_user_path(target_user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in for users list" do
        get admin_users_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in for user details" do
        get admin_user_path(target_user)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end