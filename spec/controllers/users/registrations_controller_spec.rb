require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "PUT #update" do
    context "when user is an OAuth user" do
      let(:oauth_user) { create(:user, :google) }

      before do
        sign_in oauth_user
      end

      it "redirects to account path with alert" do
        put :update, params: { user: { email: 'new@example.com', current_password: 'password' } }

        expect(flash[:alert]).to eq("Not allowed for OAuth user.")
        expect(response).to redirect_to(users_account_path)
      end
    end

    context "when user is a regular user" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "updates the password and redirects to edit" do
        put :update, params: {
          user: {
            password: 'newpassword',
            password_confirmation: 'newpassword',
            current_password: 'password'
          }
        }

        expect(response).to redirect_to(edit_user_registration_path)
      end
    end
  end

  describe "GET #new" do
    context "when signups are disabled" do
      it "redirects with alert" do
        allow(User).to receive(:disabled_signup?).and_return(true)

        get :new

        expect(flash[:alert]).to eq("New registrations are currently disabled.")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
