require 'rails_helper'

RSpec.describe "Project Access Security", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:owner) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:unauthorized_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }
  
  let(:project) { create(:project, user: owner) }
  let(:other_project) { create(:project, user: unauthorized_user) }
  
  before do
    # Invite one user to the project
    project.users << invited_user
  end

  describe "Project show and edit access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows access to own project" do
        get project_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows access to project edit page" do
        get edit_project_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows updating own project" do
        patch project_path(project), params: { project: { name: "Updated Name" } }
        expect(response).to have_http_status(:found) # redirect after update
      end

      it "allows deleting own project" do
        delete project_path(project)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "denies access to other user's project" do
        get project_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows access to invited project" do
        get project_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to project edit page" do
        get edit_project_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies updating project" do
        patch project_path(project), params: { project: { name: "Updated Name" } }
        expect(response).to have_http_status(:not_found)
      end

      it "denies deleting project" do
        delete project_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies access to unauthorized project" do
        get project_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project" do
        get project_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies access to project edit page" do
        get edit_project_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies updating project" do
        patch project_path(project), params: { project: { name: "Updated Name" } }
        expect(response).to have_http_status(:not_found)
      end

      it "denies deleting project" do
        delete project_path(project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in for project access" do
        get project_path(project)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in for project edit" do
        get edit_project_path(project)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "Project import/export access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows access to import page" do
        get new_project_import_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows exporting project" do
        post project_export_path(project, format: :json)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "denies access to import page" do
        get new_project_import_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies exporting project" do
        post project_export_path(project, format: :json)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to import page" do
        get new_project_import_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies exporting project" do
        post project_export_path(project, format: :json)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
