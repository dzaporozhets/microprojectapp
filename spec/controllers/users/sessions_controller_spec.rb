require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'when user has 2FA enabled' do
      before do
        user.update(otp_required_for_login: true)

        allow(controller).to receive(:send_two_factor_authentication_code).and_return(true)
      end

      it 'sends OTP when credentials are valid and renders OTP form' do
        post :create, params: { user: { email: user.email, password: user.password } }

        expect(session[:otp_user_id]).to eq(user.id)
        expect(controller).to have_received(:send_two_factor_authentication_code)
      end

      describe 'otp_attempt is present' do
        before do
          session[:otp_user_id] = user.id
        end

        it 'verifies OTP and signs in the user when OTP is correct' do
          allow(controller).to receive(:valid_otp_attempt?).and_return(true)

          post :create, params: { user: { email: user.email, password: user.password, otp_attempt: '123456' } }

          expect(controller.current_user).to eq(user)
          expect(session[:otp_user_id]).to be_nil
          expect(response).to redirect_to(root_path)
        end

        it 'does not sign in the user when OTP is incorrect' do
          allow(controller).to receive(:valid_otp_attempt?).and_return(false)

          post :create, params: { user: { email: user.email, password: user.password, otp_attempt: '123456' } }

          expect(controller.current_user).to be_nil
          expect(session[:otp_user_id]).to eq(user.id)
          expect(flash[:alert]).to eq('Invalid two-factor code.')
        end
      end
    end

    context 'when user does not have 2FA enabled' do
      it 'signs in the user normally' do
        post :create, params: { user: { email: user.email, password: user.password } }

        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
