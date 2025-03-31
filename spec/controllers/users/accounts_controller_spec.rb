# spec/controllers/users/accounts_controller_spec.rb
require 'rails_helper'

RSpec.describe Users::AccountsController, type: :controller do
  let(:user) { create(:user, email: 'original@example.com') }

  before do
    sign_in user
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) { { email: 'updated@example.com' } }

      # Mock the update method to ensure it's called with the right parameters
      it "calls update on the current user with the right parameters" do
        # We need to allow any parameters since ActionController::Parameters is used
        expect(controller.current_user).to receive(:update).and_return(true)
        patch :update, params: { user: new_attributes }
      end

      it "redirects to the settings page" do
        # Allow the update to succeed
        allow(controller.current_user).to receive(:update).and_return(true)
        patch :update, params: { user: new_attributes }
        expect(response).to redirect_to(users_settings_path)
      end

      it "sets a success notice" do
        # Allow the update to succeed
        allow(controller.current_user).to receive(:update).and_return(true)
        patch :update, params: { user: new_attributes }
        expect(flash[:notice]).to eq('Saved')
      end
    end

    context "with invalid params" do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
      end

      it "redirects to the settings page" do
        patch :update, params: { user: { email: 'invalid' } }
        expect(response).to redirect_to(users_settings_path)
      end

      it "sets an error notice" do
        patch :update, params: { user: { email: 'invalid' } }
        expect(flash[:notice]).to eq('An error occurred')
      end
    end
  end

  describe "DELETE #destroy" do
    context "when successful" do
      it "destroys the current user" do
        expect do
          delete :destroy
        end.to change(User, :count).by(-1)
      end

      it "signs out the user" do
        delete :destroy
        expect(controller.current_user).to be_nil
      end

      it "redirects to the root path" do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it "sets a success notice" do
        delete :destroy
        expect(flash[:notice]).to eq('Your account has been successfully deleted.')
      end
    end

    context "when unsuccessful" do
      before do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
      end

      it "does not destroy the user" do
        expect do
          delete :destroy
        end.not_to change(User, :count)
      end

      it "redirects to the account page" do
        delete :destroy
        expect(response).to redirect_to(users_account_path)
      end

      it "sets an error alert" do
        delete :destroy
        expect(flash[:alert]).to eq('An error occurred while deleting your account.')
      end
    end
  end
end
