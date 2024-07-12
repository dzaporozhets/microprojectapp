require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:project_users).dependent(:destroy) }
    it { should have_many(:users).through(:project_users) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user_id) }
  end

  describe "methods" do
    describe "#create_sample_tasks" do
      it "creates sample tasks associated with the project" do
        expect { project.create_sample_tasks }.to change { project.tasks.count }.by(14)
      end
    end

    describe "#create_sample_links" do
      it "creates sample links associated with the project" do
        expect { project.create_sample_links }.to change { project.links.count }.by(2)
      end
    end
  end

   describe "#team" do
    it "returns an array containing the user and additional users" do
      additional_user = create(:user)
      project.users << additional_user

      expect(project.team).to contain_exactly(user, additional_user)
    end

    it "returns an array containing only the user if there are no additional users" do
      expect(project.team).to contain_exactly(user)
    end
  end
end

