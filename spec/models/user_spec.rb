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

    it "creates a sample project after user creation" do
      sample_project = user.projects.find_by(name: "Sample")

      expect(sample_project).not_to be_nil
      expect(sample_project.tasks.count).to eq(14)
      expect(sample_project.links.count).to eq(2)
    end
  end

  describe 'class_methods' do
    describe '.from_omniauth' do
      let(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '123456789',
          info: {
            email: 'user@mydomain.com'
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
        end
      end

      context 'when the user exists' do
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
        user.projects.find_by(name: "Sample")&.destroy
        user.create_sample_project
        sample_project = user.projects.find_by(name: "Sample")

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
  end
end
