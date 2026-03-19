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

  describe "POST #create with attachment" do
    context "when file storage is enabled" do
      before do
        allow(controller).to receive(:file_storage_enabled?).and_return(true)
      end

      it "creates a note with an attachment" do
        file = fixture_file_upload(
          Rails.root.join('spec/fixtures/files/test_file.txt'),
          'text/plain'
        )

        expect {
          post :create, params: {
            project_id: project.id,
            note: { title: "With file", content: "Content", attachment: file }
          }
        }.to change(Note, :count).by(1)

        note = Note.last
        expect(note.attachment).to be_attached
        expect(note.attachment.filename.to_s).to eq('test_file.txt')
      end
    end

    context "when file storage is disabled" do
      before do
        allow(controller).to receive(:file_storage_enabled?).and_return(false)
      end

      it "creates a note but strips the attachment" do
        file = fixture_file_upload(
          Rails.root.join('spec/fixtures/files/test_file.txt'),
          'text/plain'
        )

        expect {
          post :create, params: {
            project_id: project.id,
            note: { title: "No file", content: "Content", attachment: file }
          }
        }.to change(Note, :count).by(1)

        note = Note.last
        expect(note.attachment).not_to be_attached
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      note = create(:note, project: project, user: user)
      get :edit, params: { project_id: project.id, id: note.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the note" do
        note = create(:note, project: project, user: user, title: "Old Title")

        patch :update, params: {
          project_id: project.id,
          id: note.id,
          note: { title: "New Title", content: "Updated content" }
        }

        note.reload
        expect(note.title).to eq("New Title")
        expect(note.content).to eq("Updated content")
        expect(response).to redirect_to(project_note_path(project, note))
      end
    end

    context "with invalid params" do
      it "renders edit with unprocessable entity" do
        note = create(:note, project: project, user: user)

        patch :update, params: {
          project_id: project.id,
          id: note.id,
          note: { title: "" }
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
