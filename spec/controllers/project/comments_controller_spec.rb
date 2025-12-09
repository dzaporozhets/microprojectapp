require 'rails_helper'

RSpec.describe Project::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project, user: user) }
  let!(:comment) { create(:comment, task: task, user: user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe "DELETE #destroy" do
    context "with HTML format" do
      it "soft deletes the comment" do
        expect do
          delete :destroy, params: {
            project_id: project.id,
            task_id: task.id,
            id: comment.id
          }
        end.not_to change(Comment, :count)

        expect(comment.reload.removed_at).to be_present
        expect(response).to redirect_to(details_project_task_path(project, task))
        expect(flash[:notice]).to eq('Comment was successfully deleted.')
      end
    end

    context "with Turbo Stream format" do
      it "soft deletes the comment and responds with turbo_stream" do
        expect do
          delete :destroy, params: {
            project_id: project.id,
            task_id: task.id,
            id: comment.id
          }, format: :turbo_stream
        end.not_to change(Comment, :count)

        expect(comment.reload.removed_at).to be_present
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context "when user is not authorized" do
      before do
        sign_out user
        sign_in other_user
      end

      it "raises RecordNotFound" do
        expect do
          delete :destroy, params: {
            project_id: project.id,
            task_id: task.id,
            id: comment.id
          }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
