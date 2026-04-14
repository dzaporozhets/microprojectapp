require 'rails_helper'

RSpec.describe "Api::V1::Comments", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project, user: user) }
  let(:token) { user.generate_api_token! }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "POST /api/v1/projects/:project_id/tasks/:task_id/comments" do
    it "returns 401 without a token" do
      post api_v1_project_task_comments_path(project, task), params: { comment: { body: "Hi" } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 403 for a project the user does not have access to" do
      other_project = create(:project)
      other_task = create(:task, project: other_project, user: other_project.user)

      post api_v1_project_task_comments_path(other_project, other_task),
        params: { comment: { body: "Hi" } }, headers: headers, as: :json

      expect(response).to have_http_status(:forbidden)
    end

    it "returns 404 for a task in a different project" do
      other_project = create(:project, user: user)
      other_task = create(:task, project: other_project, user: user)

      post api_v1_project_task_comments_path(project, other_task),
        params: { comment: { body: "Hi" } }, headers: headers, as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "creates a comment" do
      expect {
        post api_v1_project_task_comments_path(project, task),
          params: { comment: { body: "Looks good" } }, headers: headers, as: :json
      }.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body['comment']['body']).to eq("Looks good")
      expect(body['comment']['user_email']).to eq(user.email)
    end

    it "creates an activity log entry" do
      expect {
        post api_v1_project_task_comments_path(project, task),
          params: { comment: { body: "Logged" } }, headers: headers, as: :json
      }.to change(Activity, :count).by(1)
    end

    it "returns 422 when body is blank" do
      post api_v1_project_task_comments_path(project, task),
        params: { comment: { body: "" } }, headers: headers, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = response.parsed_body
      expect(body['errors']).to include("Body can't be blank")
    end
  end
end
