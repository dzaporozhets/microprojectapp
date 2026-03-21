require 'rails_helper'

RSpec.describe "Notes", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "GET /notes/new" do
    it "renders the new note form" do
      get new_note_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New note")
    end
  end

  describe "POST /notes" do
    it "creates a note and redirects to notes index" do
      expect {
        post notes_path, params: { note: { project_id: project.id, title: "Test note", content: "Some content" } }
      }.to change(Note, :count).by(1)

      expect(response).to redirect_to(notes_path)
    end

    it "rejects an invalid project" do
      post notes_path, params: { note: { project_id: 0, title: "Test note" } }

      expect(response).to redirect_to(notes_path)
      expect(flash[:alert]).to eq("Invalid project.")
    end

    it "re-renders the form when note is invalid" do
      post notes_path, params: { note: { project_id: project.id, title: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects an archived project" do
      project.update!(archived: true)

      post notes_path, params: { note: { project_id: project.id, title: "Test note" } }

      expect(response).to redirect_to(notes_path)
      expect(flash[:alert]).to eq("Invalid project.")
    end
  end
end
