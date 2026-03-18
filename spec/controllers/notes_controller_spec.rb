require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns notes from user's projects" do
      create(:note, project: project, user: user, title: "My note")
      get :index
      expect(response).to be_successful
    end

    it "does not include notes from inaccessible projects" do
      other_user = create(:user)
      other_project = create(:project, user: other_user)
      create(:note, project: other_project, user: other_user, title: "Secret note")

      get :index
      expect(response).to be_successful
    end
  end
end
