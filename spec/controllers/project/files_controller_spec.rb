require 'rails_helper'

RSpec.describe Project::FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, :with_files, user: user) }

  before do
    sign_in user
  end

  describe "GET #download" do
    context "when file exists with local storage" do
      it "sends the file" do
        file = project.project_files.first
        get :download, params: { project_id: project.id, file: file.identifier }
        expect(response).to be_successful
      end
    end

    context "when file exists with S3 storage" do
      it "sends file data" do
        file = project.project_files.first
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('AWS_S3_BUCKET').and_return('my-bucket')
        allow(file).to receive(:read).and_return('file contents')
        allow(file).to receive(:content_type).and_return('text/plain')
        allow_any_instance_of(Project).to receive(:project_files).and_return([file])

        get :download, params: { project_id: project.id, file: file.identifier }
        expect(response).to be_successful
      end
    end

    context "when file does not exist" do
      it "redirects with alert" do
        get :download, params: { project_id: project.id, file: 'nonexistent.txt' }
        expect(response).to redirect_to(project_path(project))
        expect(flash[:alert]).to eq('File not found.')
      end
    end
  end
end
