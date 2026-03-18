require 'rails_helper'

RSpec.describe Project::NotesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { project_id: project.id }
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      note = create(:note, project: project, user: user)
      get :show, params: { project_id: project.id, id: note.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: { project_id: project.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a note" do
        expect {
          post :create, params: {
            project_id: project.id,
            note: { title: "My Note", content: "Some content" }
          }
        }.to change(Note, :count).by(1)
        expect(response).to redirect_to(project_notes_path(project))
      end
    end

    context "with invalid params" do
      it "renders new with unprocessable entity" do
        post :create, params: {
          project_id: project.id,
          note: { title: "", content: "" }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the note" do
      note = create(:note, project: project, user: user)

      expect {
        delete :destroy, params: { project_id: project.id, id: note.id }
      }.to change(Note, :count).by(-1)
      expect(response).to redirect_to(project_notes_path(project))
    end
  end
end
