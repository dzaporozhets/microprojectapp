require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task_todo) { create(:task, project: project, user: user, done: false, star: true) }
  let!(:task_done) { create(:task, project: project, user: user, done: true) }
  let(:token) { user.generate_api_token!; user.api_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "authentication" do
    it "returns 401 without a token" do
      get api_v1_project_tasks_path(project)
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with an invalid token" do
      get api_v1_project_tasks_path(project), headers: { 'Authorization' => 'Bearer bad_token' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "authorization" do
    it "returns 403 for a project the user does not have access to" do
      other_project = create(:project)

      get api_v1_project_tasks_path(other_project), headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/v1/projects/:project_id/tasks" do
    it "returns all tasks" do
      get api_v1_project_tasks_path(project), headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['project']['id']).to eq(project.id)
      expect(body['project']['name']).to eq(project.name)
      expect(body['tasks'].size).to eq(2)
    end

    it "filters by status=todo" do
      get api_v1_project_tasks_path(project), params: { status: 'todo' }, headers: headers

      body = JSON.parse(response.body)
      expect(body['tasks'].size).to eq(1)
      expect(body['tasks'][0]['done']).to be false
    end

    it "filters by status=done" do
      get api_v1_project_tasks_path(project), params: { status: 'done' }, headers: headers

      body = JSON.parse(response.body)
      expect(body['tasks'].size).to eq(1)
      expect(body['tasks'][0]['done']).to be true
    end

    it "includes comment_count" do
      create(:comment, task: task_todo, user: user)
      create(:comment, task: task_todo, user: user)

      get api_v1_project_tasks_path(project), headers: headers

      body = JSON.parse(response.body)
      todo_json = body['tasks'].find { |t| t['id'] == task_todo.id }
      expect(todo_json['comment_count']).to eq(2)
    end
  end

  describe "GET /api/v1/projects/:project_id/tasks/:id" do
    it "returns task with comments" do
      comment = create(:comment, task: task_todo, user: user)

      get api_v1_project_task_path(project, task_todo), headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['task']['id']).to eq(task_todo.id)
      expect(body['task']['description']).to eq(task_todo.description)
      expect(body['task']['comments'].size).to eq(1)
      expect(body['task']['comments'][0]['body']).to eq(comment.body)
    end

    it "excludes soft-deleted comments" do
      create(:comment, task: task_todo, user: user)
      create(:comment, task: task_todo, user: user, removed_at: Time.current)

      get api_v1_project_task_path(project, task_todo), headers: headers

      body = JSON.parse(response.body)
      expect(body['task']['comments'].size).to eq(1)
    end

    it "returns 404 for a task in a different project" do
      other_project = create(:project, user: user)
      other_task = create(:task, project: other_project, user: user)

      get api_v1_project_task_path(project, other_task), headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/projects/:project_id/tasks/:id/toggle_done" do
    it "toggles a todo task to done" do
      patch toggle_done_api_v1_project_task_path(project, task_todo), headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['task']['done']).to be true
      expect(task_todo.reload.done).to be true
    end

    it "toggles a done task to todo" do
      patch toggle_done_api_v1_project_task_path(project, task_done), headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['task']['done']).to be false
      expect(task_done.reload.done).to be false
    end

    it "creates an activity log entry" do
      expect {
        patch toggle_done_api_v1_project_task_path(project, task_todo), headers: headers
      }.to change(Activity, :count).by(1)
    end
  end
end
