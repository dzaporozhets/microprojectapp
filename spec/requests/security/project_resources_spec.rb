require 'rails_helper'

RSpec.describe "Project Resources Security", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:owner) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:unauthorized_user) { create(:user) }
  
  let(:project) { create(:project, user: owner) }
  let(:other_project) { create(:project, user: unauthorized_user) }
  
  let(:link) { create(:link, project: project, user: owner) }
  let(:note) { create(:note, project: project, user: owner) }
  
  before do
    # Invite one user to the project
    project.users << invited_user
  end

  describe "Project links access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing links index" do
        get project_links_path(project)
        expect(response).to have_http_status(:found) # redirects to overview
      end

      it "allows viewing link details" do
        get project_link_path(project, link)
        expect(response).to have_http_status(:ok)
      end

      it "allows accessing new link page" do
        get new_project_link_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows creating links" do
        post project_links_path(project), params: { link: { url: "https://example.com" } }
        expect(response).to have_http_status(:found) # redirect after creation
      end

      it "allows deleting links" do
        delete project_link_path(project, link)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "denies access to other project's links" do
        get project_links_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing links index" do
        get project_links_path(project)
        expect(response).to have_http_status(:found) # redirects to overview
      end

      it "allows viewing link details" do
        get project_link_path(project, link)
        expect(response).to have_http_status(:ok)
      end

      it "allows accessing new link page" do
        get new_project_link_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows creating links" do
        post project_links_path(project), params: { link: { url: "https://example.com" } }
        expect(response).to have_http_status(:found) # redirect after creation
      end

      it "allows deleting own links" do
        invited_link = create(:link, project: project, user: invited_user)
        delete project_link_path(project, invited_link)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "denies access to unauthorized project's links" do
        get project_links_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project links" do
        get project_links_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies creating links" do
        post project_links_path(project), params: { link: { url: "https://example.com" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "Project notes access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing notes index" do
        get project_notes_path(project)
        expect(response).to have_http_status(:found) # redirects to overview
      end

      it "allows viewing note details" do
        get project_note_path(project, note)
        expect(response).to have_http_status(:ok)
      end

      it "allows accessing new note page" do
        get new_project_note_path(project)
        expect(response).to have_http_status(:found) # redirects to edit after creating note
      end

      it "allows accessing edit note page" do
        get edit_project_note_path(project, note)
        expect(response).to have_http_status(:ok)
      end


      it "allows updating notes" do
        patch project_note_path(project, note), params: { note: { content: "Updated content" } }
        expect(response).to have_http_status(:found) # redirect after update
      end

      it "allows deleting notes" do
        delete project_note_path(project, note)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "allows viewing note history" do
        get history_project_note_path(project, note)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to other project's notes" do
        get project_notes_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing notes index" do
        get project_notes_path(project)
        expect(response).to have_http_status(:found) # redirects to overview
      end

      it "allows viewing note details" do
        get project_note_path(project, note)
        expect(response).to have_http_status(:ok)
      end

      it "allows accessing new note page" do
        get new_project_note_path(project)
        expect(response).to have_http_status(:found) # redirects to edit after creating note
      end


      it "allows editing own notes" do
        invited_note = create(:note, project: project, user: invited_user)
        get edit_project_note_path(project, invited_note)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to unauthorized project's notes" do
        get project_notes_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project notes" do
        get project_notes_path(project)
        expect(response).to have_http_status(:not_found)
      end

    end
  end

  describe "Project files access" do
    before do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        Rails.application.config.app_settings.merge(enable_local_file_storage: true)
      )
    end

    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing files index" do
        get project_files_path(project)
        expect(response).to have_http_status(:found) # redirects to overview
      end

      it "allows accessing new file page" do
        get new_project_file_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to other project's files" do
        get project_files_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing files index" do
        get project_files_path(project)
        expect(response).to have_http_status(:found) # redirects to overview
      end

      it "allows accessing new file page" do
        get new_project_file_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to unauthorized project's files" do
        get project_files_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project files" do
        get project_files_path(project)
        expect(response).to have_http_status(:not_found)
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
        sign_in owner
      end

      it "redirects when accessing new file page" do
        get new_project_file_path(project)
        expect(response).to have_http_status(:found)
      end
    end
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

  describe "Project schedule access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing project schedule" do
        get project_schedule_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows saturating schedule" do
        post saturate_project_schedule_path(project)
        expect(response).to have_http_status(:found) # redirect after saturation
      end

      it "denies access to other project's schedule" do
        get project_schedule_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing project schedule" do
        get project_schedule_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows saturating schedule" do
        post saturate_project_schedule_path(project)
        expect(response).to have_http_status(:found) # redirect after saturation
      end

      it "denies access to unauthorized project's schedule" do
        get project_schedule_path(other_project)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project schedule" do
        get project_schedule_path(project)
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