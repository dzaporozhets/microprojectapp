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
      create(:note, project: project, user: user, title: "Search notes for Q3")
      create(:link, project: project, user: user, title: "Search docs", url: "https://example.com/search-docs")

      get search_path(query: "search")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ship search feature")
      expect(response.body).to include(project.name)
      expect(response.body).to include("Search notes for Q3")
      expect(response.body).to include("Search docs")
    end

    it "does not return resources from other projects" do
      other_project = create(:project)
      create(:task, name: "Hidden task", project: other_project, user: create(:user))
      create(:note, title: "Hidden note", project: other_project, user: create(:user))
      create(:link, title: "Hidden link", project: other_project, user: create(:user))

      get search_path(query: "Hidden")

      expect(response.body).not_to include("Hidden task")
      expect(response.body).not_to include("Hidden note")
      expect(response.body).not_to include("Hidden link")
    end
  end
end
