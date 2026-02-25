require 'rails_helper'

RSpec.describe 'Users::Accounts', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before { sign_in user }

  describe 'POST /users/account/generate_api_token' do
    it 'generates a token and redirects' do
      post generate_api_token_users_account_path

      expect(response).to redirect_to(users_account_path)
      expect(user.reload.api_token_digest).to be_present
      expect(user.api_token_last8).to be_present
    end

    it 'includes the raw token in flash' do
      post generate_api_token_users_account_path

      expect(flash[:api_token]).to match(/\A[0-9a-f]{64}\z/)
    end

    it 'regenerates an existing token' do
      user.generate_api_token!
      old_digest = user.api_token_digest

      post generate_api_token_users_account_path

      expect(user.reload.api_token_digest).not_to eq(old_digest)
    end
  end

  describe 'DELETE /users/account/revoke_api_token' do
    it 'revokes the token and redirects' do
      user.generate_api_token!

      delete revoke_api_token_users_account_path

      expect(response).to redirect_to(users_account_path)
      expect(user.reload.api_token_digest).to be_nil
      expect(user.api_token_last8).to be_nil
    end

    it 'invalidates API access' do
      raw_token = user.generate_api_token!

      delete revoke_api_token_users_account_path

      get api_v1_project_tasks_path(create(:project, user: user)),
          headers: { 'Authorization' => "Bearer #{raw_token}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
