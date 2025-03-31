require 'rails_helper'

RSpec.describe Project::UsersController, type: :controller do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:non_member) { create(:user) }
  let(:project) { create(:project, user: owner) }

  before do
    project.users << member
  end

  describe "DELETE #leave" do
    context "when user is a member of the project" do
      before do
        sign_in member
      end

      it "removes the current user from the project" do
        expect {
          delete :leave, params: { project_id: project.id }
        }.to change { project.reload.users.count }.by(-1)

        expect(project.users).not_to include(member)
        expect(response).to redirect_to(projects_path)
        expect(flash[:notice]).to eq('You left the project.')
      end
    end

    context "when user is the owner of the project" do
      before do
        sign_in owner
      end

      it "does not remove the owner from the project" do
        expect {
          delete :leave, params: { project_id: project.id }
        }.not_to change { project.reload.users.count }

        # The controller returns a 204 No Content status for owners
        expect(response.status).to eq(204)
      end
    end

    context "when user is not a member of the project" do
      before do
        sign_in non_member
      end

      it "raises RecordNotFound due to authorization" do
        expect {
          delete :leave, params: { project_id: project.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end