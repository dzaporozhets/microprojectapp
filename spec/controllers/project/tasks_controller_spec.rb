require 'rails_helper'

RSpec.describe Project::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:non_team_user) { create(:user) }
  let(:task) { create(:task, project: project, user: user, assigned_user: nil) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns tasks for the project" do
      task
      get :index, params: { project_id: project.id }
      expect(response).to be_successful
    end

    context "with assigned_user_id filter" do
      it "returns successfully" do
        create(:task, project: project, user: user, assigned_user: user)
        get :index, params: { project_id: project.id, assigned_user_id: user.id }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #new" do
    it "returns a new task form" do
      get :new, params: { project_id: project.id }
      expect(response).to be_successful
    end

    context "when project is archived" do
      before { project.update!(archived: true) }

      it "redirects with alert" do
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(project_url(project))
        expect(flash[:alert]).to eq("Cannot add tasks to an archived project.")
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a task" do
        expect {
          post :create, params: { project_id: project.id, task: { name: "New task" } }
        }.to change(Task, :count).by(1)
        expect(response).to redirect_to(project_url(project))
      end
    end

    context "with invalid params" do
      it "does not create a task" do
        expect {
          post :create, params: { project_id: project.id, task: { name: "" } }
        }.not_to change(Task, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when project is archived" do
      before { project.update!(archived: true) }

      it "redirects with alert" do
        post :create, params: { project_id: project.id, task: { name: "New task" } }
        expect(response).to redirect_to(project_url(project))
        expect(flash[:alert]).to eq("Cannot add tasks to an archived project.")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid assigned_user_id" do
      it "updates the task and assigns it to the valid user" do
        patch :update, params: {
          project_id: project.id,
          id: task.id,
          task: { assigned_user_id: user.id }
        }

        task.reload

        expect(task.assigned_user).to eq(user)
        expect(response).to redirect_to(details_project_task_path(project, task))
        expect(flash[:notice]).to eq("Task was successfully updated.")
      end
    end

    context "with invalid assigned_user_id" do
      it "does not assign the task to an invalid user" do
        patch :update, params: {
          project_id: project.id,
          id: task.id,
          task: { assigned_user_id: non_team_user.id }
        }

        task.reload

        expect(task.assigned_user).to be_nil
        expect(response).to redirect_to(details_project_task_path(project, task))
        expect(flash[:alert]).to eq("Assigned user must be a member of the project team.")
      end
    end

    context "with invalid task params" do
      it "re-renders the edit form" do
        patch :update, params: {
          project_id: project.id,
          id: task.id,
          task: { name: "" }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the task" do
      task
      expect {
        delete :destroy, params: { project_id: project.id, id: task.id }
      }.to change(Task, :count).by(-1)
      expect(response).to redirect_to(project_url(project))
    end
  end

  describe "PATCH #toggle_done" do
    it "toggles the task done status" do
      patch :toggle_done, params: {
        project_id: project.id,
        id: task.id,
        task: { done: true }
      }

      task.reload
      expect(task.done).to be true
      expect(response).to redirect_to(project_path(project))
    end
  end

  describe "PATCH #toggle_star" do
    it "toggles the task star status" do
      expect(task.star).to be false

      patch :toggle_star, params: { project_id: project.id, id: task.id }

      task.reload
      expect(task.star).to be true
      expect(response).to redirect_to(project_url(project))
    end
  end

  describe "GET #completed" do
    it "returns completed tasks" do
      create(:task, project: project, user: user, done: true)
      get :completed, params: { project_id: project.id }
      expect(response).to be_successful
    end
  end

  describe "GET #changes" do
    it "returns the task versions" do
      get :changes, params: { project_id: project.id, id: task.id }
      expect(response).to be_successful
    end
  end
end
