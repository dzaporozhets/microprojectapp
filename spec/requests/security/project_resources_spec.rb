require 'rails_helper'

RSpec.describe "Project Resources Security", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:owner) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:unauthorized_user) { create(:user) }
  
  let(:project) { create(:project, user: owner) }
  let(:other_project) { create(:project, user: unauthorized_user) }
  
  before do
    # Invite one user to the project
    project.users << invited_user
  end

  describe "Project team management access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing team members" do
        get project_users_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows accessing invite page" do
        get invite_project_users_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows adding team members" do
        new_user = create(:user)
        post add_member_project_users_path(project), params: { email: new_user.email }
        expect(response).to have_http_status(:found) # redirect after adding
      end

      it "allows removing team members" do
        delete project_user_path(project, invited_user)
        expect(response).to have_http_status(:found) # redirect after removal
      end

      it "denies access to other project's team" do
        get project_users_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing team members" do
        get project_users_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies accessing invite page" do
        get invite_project_users_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies adding team members" do
        new_user = create(:user)
        post add_member_project_users_path(project), params: { email: new_user.email }
        expect(response).to have_http_status(:not_found)
      end

      it "allows leaving project" do
        delete leave_project_users_path(project)
        expect(response).to have_http_status(:found) # redirect after leaving
      end

      it "denies access to unauthorized project's team" do
        get project_users_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project team" do
        get project_users_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies adding team members" do
        post add_member_project_users_path(project), params: { email: "test@example.com" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "Project activity access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing project activity" do
        get project_activity_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to other project's activity" do
        get project_activity_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing project activity" do
        get project_activity_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to unauthorized project's activity" do
        get project_activity_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project activity" do
        get project_activity_path(project)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
