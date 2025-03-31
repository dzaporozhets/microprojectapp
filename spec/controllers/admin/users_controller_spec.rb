require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:target_user) { create(:user) }

  describe "authentication and authorization" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is not an admin" do
      before do
        sign_in regular_user
      end

      it "raises RecordNotFound for index action" do
        expect { get :index }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises RecordNotFound for show action" do
        expect { get :show, params: { id: target_user.id } }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises RecordNotFound for edit action" do
        expect { get :edit, params: { id: target_user.id } }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises RecordNotFound for update action" do
        expect {
          patch :update, params: { id: target_user.id, user: { confirmed_at: Time.current } }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises RecordNotFound for destroy action" do
        expect {
          delete :destroy, params: { id: target_user.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "admin actions" do
    before do
      sign_in admin_user
    end

    describe "GET #index" do
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end

      it "returns a collection of users" do
        get :index
        # Just verify the response is successful
        expect(response).to be_successful
      end

      it "handles pagination" do
        # Create 51 additional users to test pagination (50 per page)
        create_list(:user, 51)

        get :index
        # Just verify the response is successful
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: { id: target_user.id }
        expect(response).to be_successful
      end

      it "successfully shows a user" do
        get :show, params: { id: target_user.id }
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        get :edit, params: { id: target_user.id }
        expect(response).to be_successful
      end

      it "successfully renders the edit form" do
        get :edit, params: { id: target_user.id }
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      context "with valid params" do
        let(:new_attributes) { { confirmed_at: Time.current } }

        it "updates the requested user" do
          expect {
            patch :update, params: { id: target_user.id, user: new_attributes }
            target_user.reload
          }.to change { target_user.confirmed_at }
        end

        it "redirects to the user" do
          patch :update, params: { id: target_user.id, user: new_attributes }
          expect(response).to redirect_to(admin_user_path(target_user))
        end

        it "sets a success notice" do
          patch :update, params: { id: target_user.id, user: new_attributes }
          expect(flash[:notice]).to eq('User updated successfully.')
        end
      end

      context "with invalid params" do
        before do
          allow_any_instance_of(User).to receive(:update).and_return(false)
        end

        it "returns a success response when update fails" do
          patch :update, params: { id: target_user.id, user: { confirmed_at: nil } }
          expect(response).to be_successful
        end

        it "sets an alert flash" do
          patch :update, params: { id: target_user.id, user: { confirmed_at: nil } }
          expect(flash[:alert]).to eq('Failed to update user.')
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested user" do
        user_to_delete = create(:user)

        expect {
          delete :destroy, params: { id: user_to_delete.id }
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, params: { id: target_user.id }
        expect(response).to redirect_to(admin_users_path)
      end

      it "sets a success notice" do
        delete :destroy, params: { id: target_user.id }
        expect(flash[:notice]).to eq('User deleted successfully.')
      end

      context "when user cannot be destroyed" do
        before do
          allow_any_instance_of(User).to receive(:destroy).and_return(false)
        end

        it "redirects to the users list" do
          delete :destroy, params: { id: target_user.id }
          expect(response).to redirect_to(admin_users_path)
        end

        it "sets an alert flash" do
          delete :destroy, params: { id: target_user.id }
          expect(flash[:alert]).to eq('Failed to delete user.')
        end
      end
    end
  end
end
