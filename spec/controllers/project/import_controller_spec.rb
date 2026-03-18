require 'rails_helper'

RSpec.describe Project::ImportController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "when ActiveRecord::RecordInvalid is raised" do
      it "redirects with error message" do
        file = fixture_file_upload('spec/fixtures/files/test_file.txt', 'application/json')
        allow(controller).to receive(:parse_json_file).and_return({ "tasks" => [] })
        allow_any_instance_of(ProjectImportValidator).to receive(:valid?).and_return(true)
        allow_any_instance_of(ProjectImportService).to receive(:import!).and_raise(ActiveRecord::RecordInvalid)

        post :create, params: { project_id: project.id, file: file }

        expect(response).to redirect_to(new_project_import_path(project))
      end
    end

    context "when ImportFormatError is raised" do
      it "redirects with error message" do
        file = fixture_file_upload('spec/fixtures/files/test_file.txt', 'application/json')
        allow(controller).to receive(:parse_json_file).and_return({ "tasks" => [] })
        allow_any_instance_of(ProjectImportValidator).to receive(:valid?).and_return(true)
        allow_any_instance_of(ProjectImportService).to receive(:import!).and_raise(ProjectImportService::ImportFormatError, "Bad format")

        post :create, params: { project_id: project.id, file: file }

        expect(response).to redirect_to(new_project_import_path(project))
        expect(flash[:alert]).to eq("Bad format")
      end
    end

    context "when StandardError is raised" do
      it "redirects with generic error message" do
        file = fixture_file_upload('spec/fixtures/files/test_file.txt', 'application/json')
        allow(controller).to receive(:parse_json_file).and_return({ "tasks" => [] })
        allow_any_instance_of(ProjectImportValidator).to receive(:valid?).and_return(true)
        allow_any_instance_of(ProjectImportService).to receive(:import!).and_raise(StandardError, "something")

        post :create, params: { project_id: project.id, file: file }

        expect(response).to redirect_to(new_project_import_path(project))
        expect(flash[:alert]).to eq('An error occurred during import. Please try again.')
      end
    end
  end

  describe "GET #show" do
    context "when no import session data exists" do
      it "defaults task_ids to empty array" do
        get :show, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end
  end
end
