require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #google_oauth2' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        uid: '12345',
        provider: 'google_oauth2',
        info: { email: 'test@example.com', image: 'http://example.com/photo.jpg' }
      )
    end

    before do
      @request.env['omniauth.auth'] = auth_hash
    end

    context 'when user is found' do
      it 'signs in and redirects' do
        user = create(:user, email: 'test@example.com', uid: '12345', provider: 'google_oauth2')
        get :google_oauth2
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not found' do
      it 'redirects to sign in with alert' do
        allow(User).to receive(:from_omniauth).and_return(nil)
        get :google_oauth2
        expect(flash[:alert]).to eq("An account with this email already exists. Please sign in with email and password.")
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signups are disabled' do
      it 'redirects with error message' do
        allow(User).to receive(:from_omniauth).and_raise(User::SignupsDisabledError, "Signups are disabled")
        get :google_oauth2
        expect(flash[:alert]).to eq("Signups are disabled")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #entra_id' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        uid: 'msft-uid-123',
        provider: 'entra_id',
        info: { email: 'msuser@example.com' }
      )
    end

    before do
      @request.env['omniauth.auth'] = auth_hash
    end

    context 'when user is found' do
      it 'signs in and redirects' do
        user = create(:user, email: 'msuser@example.com', uid: 'msft-uid-123', provider: 'entra_id')
        get :entra_id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not found' do
      it 'redirects to sign in with alert' do
        allow(User).to receive(:from_omniauth).and_return(nil)
        get :entra_id
        expect(flash[:alert]).to eq("An account with this email already exists. Please sign in with email and password.")
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signups are disabled' do
      it 'redirects with error message' do
        allow(User).to receive(:from_omniauth).and_raise(User::SignupsDisabledError, "Signups are disabled")
        get :entra_id
        expect(flash[:alert]).to eq("Signups are disabled")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
