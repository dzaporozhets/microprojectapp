require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_api_token! }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /api/v1/projects" do
    it "returns 401 without a token" do
      get api_v1_projects_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns projects the user owns and is invited to" do
      owned = create(:project, user: user, name: 'Owned')
      invited = create(:project, name: 'Invited')
      create(:project_user, user: user, project: invited)
      create(:project, name: 'Other')

      get api_v1_projects_path, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      names = body['projects'].map { |p| p['name'] }
      expect(names).to include('Owned', 'Invited')
      expect(names).not_to include('Other')
    end

    it "excludes archived projects" do
      create(:project, user: user, name: 'Active')
      create(:project, user: user, name: 'Archived', archived: true)

      get api_v1_projects_path, headers: headers

      body = JSON.parse(response.body)
      names = body['projects'].map { |p| p['name'] }
      expect(names).to include('Active')
      expect(names).not_to include('Archived')
    end
  end
end
