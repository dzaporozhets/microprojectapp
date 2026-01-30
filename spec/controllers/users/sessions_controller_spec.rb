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
  end
end
