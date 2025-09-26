require 'rails_helper'

RSpec.describe "Task Access Security", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:owner) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:unauthorized_user) { create(:user) }
  
  let(:project) { create(:project, user: owner) }
  let(:other_project) { create(:project, user: unauthorized_user) }
  
  let(:task) { create(:task, project: project, user: owner) }
  let(:other_task) { create(:task, project: other_project, user: unauthorized_user) }
  
  before do
    # Invite one user to the project
    project.users << invited_user
  end

  describe "Task viewing access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows viewing own project tasks" do
        get project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows viewing task details" do
        get details_project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows viewing task changes" do
        get changes_project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows viewing completed tasks" do
        get completed_project_tasks_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to other project's tasks" do
        get project_task_path(other_project, other_task)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows viewing project tasks" do
        get project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows viewing task details" do
        get details_project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows viewing completed tasks" do
        get completed_project_tasks_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "denies access to unauthorized project's tasks" do
        get project_task_path(other_project, other_task)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies access to project tasks" do
        get project_task_path(project, task)
        expect(response).to have_http_status(:not_found)
      end

      it "denies access to task details" do
        get details_project_task_path(project, task)
        expect(response).to have_http_status(:not_found)
      end

      it "denies access to completed tasks" do
        get completed_project_tasks_path(project)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "Task creation access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows accessing new task page" do
        get new_project_task_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows creating tasks" do
        post project_tasks_path(project), params: { task: { name: "New Task" } }
        expect(response).to have_http_status(:found) # redirect after creation
      end

      it "denies creating tasks in other projects" do
        post project_tasks_path(other_project), params: { task: { name: "New Task" } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows accessing new task page" do
        get new_project_task_path(project)
        expect(response).to have_http_status(:ok)
      end

      it "allows creating tasks" do
        post project_tasks_path(project), params: { task: { name: "New Task" } }
        expect(response).to have_http_status(:found) # redirect after creation
      end

      it "denies creating tasks in unauthorized projects" do
        post project_tasks_path(other_project), params: { task: { name: "New Task" } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies accessing new task page" do
        get new_project_task_path(project)
        expect(response).to have_http_status(:not_found)
      end

      it "denies creating tasks" do
        post project_tasks_path(project), params: { task: { name: "New Task" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "Task modification access" do
    context "when user is project owner" do
      before { sign_in owner }

      it "allows accessing edit task page" do
        get edit_project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows updating tasks" do
        patch project_task_path(project, task), params: { task: { name: "Updated Task" } }
        expect(response).to have_http_status(:found) # redirect after update
      end

      it "allows toggling task done status" do
        patch toggle_done_project_task_path(project, task), params: { task: { done: true } }
        expect(response).to have_http_status(:found) # redirect after toggle
      end

      it "allows toggling task star status" do
        patch toggle_star_project_task_path(project, task)
        expect(response).to have_http_status(:found) # redirect after toggle
      end

      it "allows deleting tasks" do
        delete project_task_path(project, task)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "denies modifying other project's tasks" do
        patch project_task_path(other_project, other_task), params: { task: { name: "Updated Task" } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows accessing edit task page" do
        get edit_project_task_path(project, task)
        expect(response).to have_http_status(:ok)
      end

      it "allows updating tasks" do
        patch project_task_path(project, task), params: { task: { name: "Updated Task" } }
        expect(response).to have_http_status(:found) # redirect after update
      end

      it "allows toggling task done status" do
        patch toggle_done_project_task_path(project, task), params: { task: { done: true } }
        expect(response).to have_http_status(:found) # redirect after toggle
      end

      it "allows toggling task star status" do
        patch toggle_star_project_task_path(project, task)
        expect(response).to have_http_status(:found) # redirect after toggle
      end

      it "allows deleting tasks" do
        delete project_task_path(project, task)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "denies modifying unauthorized project's tasks" do
        patch project_task_path(other_project, other_task), params: { task: { name: "Updated Task" } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies accessing edit task page" do
        get edit_project_task_path(project, task)
        expect(response).to have_http_status(:not_found)
      end

      it "denies updating tasks" do
        patch project_task_path(project, task), params: { task: { name: "Updated Task" } }
        expect(response).to have_http_status(:not_found)
      end

      it "denies toggling task done status" do
        patch toggle_done_project_task_path(project, task)
        expect(response).to have_http_status(:not_found)
      end

      it "denies toggling task star status" do
        patch toggle_star_project_task_path(project, task)
        expect(response).to have_http_status(:not_found)
      end

      it "denies deleting tasks" do
        delete project_task_path(project, task)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "Task comments access" do
    let(:comment) { create(:comment, task: task, user: owner) }
    let(:other_comment) { create(:comment, task: other_task, user: unauthorized_user) }

    context "when user is project owner" do
      before { sign_in owner }

      it "allows creating comments on own project tasks" do
        post project_task_comments_path(project, task), params: { comment: { body: "New comment" } }
        expect(response).to have_http_status(:found) # redirect after creation
      end

      it "allows deleting own comments" do
        delete project_task_comment_path(project, task, comment)
        expect(response).to have_http_status(:found) # redirect after delete
      end

      it "denies creating comments on other project's tasks" do
        post project_task_comments_path(other_project, other_task), params: { comment: { body: "New comment" } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is invited to project" do
      before { sign_in invited_user }

      it "allows creating comments on project tasks" do
        post project_task_comments_path(project, task), params: { comment: { body: "New comment" } }
        expect(response).to have_http_status(:found) # redirect after creation
      end

      it "denies creating comments on unauthorized project's tasks" do
        post project_task_comments_path(other_project, other_task), params: { comment: { body: "New comment" } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not authorized" do
      before { sign_in unauthorized_user }

      it "denies creating comments on project tasks" do
        post project_task_comments_path(project, task), params: { comment: { body: "New comment" } }
        expect(response).to have_http_status(:not_found)
      end

      it "denies deleting comments" do
        delete project_task_comment_path(project, task, comment)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end