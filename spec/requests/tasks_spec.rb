require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "GET /tasks/new" do
    it "renders the new task form" do
      get new_task_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New task")
    end
  end

  describe "POST /tasks" do
    it "creates a task and redirects to tasks index" do
      expect {
        post tasks_path, params: { task: { project_id: project.id, name: "Test task" } }
      }.to change(Task, :count).by(1)

      expect(response).to redirect_to(tasks_path)
    end

    it "rejects an invalid project" do
      post tasks_path, params: { task: { project_id: 0, name: "Test task" } }

      expect(response).to redirect_to(tasks_path)
      expect(flash[:alert]).to eq("Invalid project.")
    end

    it "re-renders the form when task is invalid" do
      post tasks_path, params: { task: { project_id: project.id, name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
