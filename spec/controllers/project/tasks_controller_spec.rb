require 'rails_helper'

RSpec.describe Project::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:non_team_user) { create(:user) }
  let(:task) { create(:task, project: project, user: user, assigned_user: nil) }

  before do
    sign_in user
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

        expect(task.assigned_user).to be_nil # assigned_user_id should remain nil
        expect(response).to redirect_to(details_project_task_path(project, task))
        expect(flash[:alert]).to eq("Assigned user must be a member of the project team.")
      end
    end
  end
end

