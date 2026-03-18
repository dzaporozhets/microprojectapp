require 'rails_helper'

RSpec.describe Project::LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a link" do
        expect {
          post :create, params: {
            project_id: project.id,
            link: { url: "https://example.com", title: "Example" }
          }
        }.to change(Link, :count).by(1)
        expect(response).to redirect_to(project_links_path(project))
      end
    end

    context "with invalid params" do
      it "renders new with unprocessable entity" do
        post :create, params: {
          project_id: project.id,
          link: { url: "", title: "" }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
