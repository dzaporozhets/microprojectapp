require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'signs in the user normally' do
        post :create, params: { user: { email: user.email, password: user.password } }

        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is an OAuth user' do
      let(:oauth_user) { create(:user, :google) }

      it 'redirects with alert instead of signing in' do
        post :create, params: { user: { email: oauth_user.email, password: 'password' } }

        expect(controller.current_user).to be_nil
        expect(flash[:alert]).to include("Please sign in with")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
