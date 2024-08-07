require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe "associations" do
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:project_users).dependent(:destroy) }
    it { should have_many(:invited_projects).through(:project_users).source(:project) }
  end

  describe "callbacks" do
    it "creates a personal project after user creation" do
      expect(user.projects.find_by(name: "Personal")).not_to be_nil
    end
  end

  describe 'class_methods' do
    describe '.from_omniauth' do
      let(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '123456789',
          info: {
            email: 'user@mydomain.com',
            image: 'http://example.com/avatar.jpg'
          }
        )
      end

      context 'when the user does not exist' do
        it 'creates a new user' do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)

          user = User.last

          expect(user.email).to eq('user@mydomain.com')
          expect(user.provider).to eq('google_oauth2')
          expect(user.uid).to eq('123456789')
          expect(user.avatar_url).to eq('http://example.com/avatar.jpg')
        end
      end

      context 'when the user exists' do
        context 'uid is nil' do
          let!(:existing_user) { create(:user, email: 'user@mydomain.com') }

          it 'returns the existing user without creating a new one' do
            expect { User.from_omniauth(auth) }.not_to change(User, :count)
          end

          it 'updates the user provider and uid' do
            User.from_omniauth(auth)
            existing_user.reload

            expect(existing_user.provider).to eq('google_oauth2')
            expect(existing_user.uid).to eq('123456789')
            expect(existing_user.avatar_url).to eq('http://example.com/avatar.jpg')
          end
        end

        context 'uid is the same' do
          let!(:existing_user) { create(:user, email: 'user@mydomain.com', provider: 'google_oauth2', uid: '123456789') }

          it 'returns the existing user without creating a new one' do
            expect { User.from_omniauth(auth) }.not_to change(User, :count)
          end

          it 'updates the user provider and uid if they differ' do
            existing_user.update(provider: 'old_provider', uid: 'old_uid')

            User.from_omniauth(auth)
            existing_user.reload

            expect(existing_user.provider).to eq('google_oauth2')
            expect(existing_user.uid).to eq('123456789')
            expect(existing_user.avatar_url).to eq('http://example.com/avatar.jpg')
          end
        end
      end
    end
  end

  describe "methods" do
    describe "#invited?" do
      it "returns false (TODO: needs implementation)" do
        expect(user.invited?).to be false
      end
    end

    describe "#admin?" do
      it "returns false by default" do
        expect(user.admin?).to be false
      end

      it "returns true for admin users" do
        admin = create(:user, :admin)

        expect(admin.admin?).to be true
      end
    end

    describe "#owns?" do
      it "returns true if the user owns the project" do
        expect(user.owns?(project)).to be true
      end

      it "returns false if the user does not own the project" do
        another_user = create(:user)
        another_project = create(:project, user: another_user)

        expect(user.owns?(another_project)).to be false
      end
    end

    describe "#create_personal_project" do
      it "does not create a second personal project" do
        expect { user.create_personal_project }.not_to change { user.projects.where(name: "Personal").count }
      end
    end

    describe "#create_sample_project" do
      it "creates a sample project with sample tasks and links" do
        sample_project = user.create_sample_project

        expect(sample_project).not_to be_nil
        expect(sample_project.tasks.count).to eq(14)
        expect(sample_project.links.count).to eq(2)
      end
    end

    describe "#personal_project" do
      it "returns the personal project" do
        expect(user.personal_project.name).to eq("Personal")
      end
    end

    describe "#has_access_to?" do
      it "returns true if the user owns the project" do
        expect(user.has_access_to?(project)).to be true
      end

      it "returns true if the user is invited to the project" do
        another_user = create(:user)
        invited_project = create(:project, user: another_user)
        invited_project.project_users.create(user: user)
        expect(user.has_access_to?(invited_project)).to be true
      end

      it "returns false if the user neither owns nor is invited to the project" do
        another_user = create(:user)
        another_project = create(:project, user: another_user)
        expect(user.has_access_to?(another_project)).to be false
      end
    end

    describe '#valid_password?' do
      let(:user) { create(:user, :google) }

      context 'when disable_password is false' do
        it 'returns true if the password is correct' do
          expect(user.valid_password?('password')).to be true
        end

        it 'returns false if the password is incorrect' do
          expect(user.valid_password?('wrongpassword')).to be false
        end
      end

      context 'when disable_password is true and OAuth is enabled' do
        let(:user) { create(:user, :google, disable_password: true) }

        before do
          allow(Devise.mappings[:user]).to receive(:omniauthable?).and_return(true)
        end

        it 'returns false regardless of the password' do
          ClimateControl.modify GOOGLE_CLIENT_ID: 'google_client_id' do
            expect(user.valid_password?('password')).to be false
            expect(user.valid_password?('wrongpassword')).to be false
          end
        end
      end

      context 'when disable_password is true and OAuth is not enabled' do
        let(:user) { create(:user, :google, disable_password: true) }

        it 'returns true if the password is correct' do
          expect(user.valid_password?('password')).to be true
        end

        it 'returns false if the password is incorrect' do
          expect(user.valid_password?('wrongpassword')).to be false
        end
      end
    end

    describe '#oauth_enabled?' do
      let(:user) { create(:user, uid: uid, provider: provider) }
      let(:uid) { nil }
      let(:provider) { nil }

      context 'when both uid and provider are present' do
        let(:uid) { 'some_uid' }
        let(:provider) { 'google' }

        it 'returns true' do
          expect(user.oauth_enabled?).to be true
        end
      end

      context 'when uid is nil' do
        it 'returns false' do
          expect(user.oauth_enabled?).to be false
        end
      end

      context 'when provider is nil' do
        it 'returns false' do
          expect(user.oauth_enabled?).to be false
        end
      end
    end

    describe '#oauth_config?' do
      before do
        allow(Devise.mappings[:user]).to receive(:omniauthable?).and_return(omniauthable)
      end

      context 'when omniauthable and GOOGLE_CLIENT_ID is present' do
        let(:omniauthable) { true }

        it 'returns true' do
          ClimateControl.modify GOOGLE_CLIENT_ID: 'google_client_id' do
            expect(user.oauth_config?).to be true
          end
        end
      end

      context 'when omniauthable is false' do
        let(:omniauthable) { false }

        it 'returns false' do
          ClimateControl.modify GOOGLE_CLIENT_ID: 'google_client_id' do
            expect(user.oauth_config?).to be false
          end
        end
      end

      context 'when GOOGLE_CLIENT_ID is nil' do
        let(:omniauthable) { true }

        it 'returns false' do
          ClimateControl.modify GOOGLE_CLIENT_ID: nil do
            expect(user.oauth_config?).to be false
          end
        end
      end
    end
  end
end
