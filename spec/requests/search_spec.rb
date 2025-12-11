require 'rails_helper'

RSpec.describe "Search", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe "GET /search" do
    it "shows a hint when the query is too short" do
      get search_path(query: "ab")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Enter at least 3 characters")
    end

    it "returns tasks from projects the user can access" do
      create(:task, project: project, user: user, name: "Ship search feature")

      get search_path(query: "search")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ship search feature")
      expect(response.body).to include(project.name)
    end

    it "does not return tasks from other projects" do
      create(:task, name: "Hidden task", project: create(:project), user: create(:user))

      get search_path(query: "Hidden")

      expect(response.body).not_to include("Hidden task")
    end
  end
end
