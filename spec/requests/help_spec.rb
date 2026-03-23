require 'rails_helper'

RSpec.describe "Help", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /help" do
    it "renders the help page" do
      get help_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("MicroProject.app")
      expect(response.body).to include(APP_VERSION)
    end
  end
end
