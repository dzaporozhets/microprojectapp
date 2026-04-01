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
      other_project = create(:project)
      create(:task, name: "Hidden task", project: other_project, user: create(:user))

      get search_path(query: "Hidden")

      expect(response.body).not_to include("Hidden task")
    end

    it "returns notes from projects the user can access" do
      create(:note, project: project, user: user, title: "Meeting notes")

      get search_path(query: "Meeting")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Meeting notes")
      expect(response.body).to include("Notes")
    end

    it "returns notes matching on content" do
      create(:note, project: project, user: user, title: "Untitled", content: "Important details here")

      get search_path(query: "Important")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Untitled")
    end

    it "does not return notes from other projects" do
      other_project = create(:project)
      create(:note, title: "Secret note", project: other_project, user: create(:user))

      get search_path(query: "Secret")

      expect(response.body).not_to include("Secret note")
    end
  end
end
