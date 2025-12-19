require 'rails_helper'

RSpec.describe 'Users::Avatars', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  describe 'GET /users/:id/avatar' do
    context 'when signed in' do
      before do
        sign_in user
      end

      it 'returns the avatar image with cache headers' do
        user.avatar = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/test_img.png'),
          'image/png'
        )
        user.save!

        get user_avatar_path(user)

        expect(response).to have_http_status(:ok)
        expect(response.headers['Cache-Control']).to eq('public, max-age=31536000, immutable')
        expect(response.media_type).to eq('image/png')
      end

      it 'returns not found when the user has no avatar' do
        get user_avatar_path(user)

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when signed out' do
      it 'redirects to sign in' do
        get user_avatar_path(user)

        expect(response).to have_http_status(:found)
      end
    end
  end
end
