require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe "associations" do
    it { is_expected.to belong_to(:user).required(true) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:links).dependent(:destroy) }
    it { is_expected.to have_many(:project_users).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:project_users) }
    it { is_expected.to have_many(:pins).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    describe "PROJECT_LIMIT" do
      before do
        stub_const("Project::PROJECT_LIMIT", 2)
      end

      it "allows creation of a project if the user has less than the limit of projects" do
        project = build(:project, :with_random_name, user: user)

        expect(project).to be_valid
      end

      it "does not allow creation of a project if the user already has the limit of projects" do
        create(:project, :with_random_name, user: user)
        project = build(:project, :with_random_name, user: user)

        expect(project).not_to be_valid
        expect(project.errors[:base]).to include("You have reached the limit of 2 projects.")
      end
    end
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

  describe "#has_team?" do
    it "returns false when no additional users" do
      expect(project.has_team?).to be false
    end

    it "returns true when there are team members" do
      project.users << create(:user)
      expect(project.has_team?).to be true
    end
  end

  describe "#personal?" do
    it "returns true for a project named Personal" do
      expect(user.personal_project.personal?).to be true
    end

    it "returns false for other projects" do
      expect(project.personal?).to be false
    end
  end

  describe "#overdue_tasks?" do
    it "returns false when no tasks are overdue" do
      create(:task, project: project, user: user, due_date: 1.day.from_now)
      expect(project.overdue_tasks?).to be false
    end

    it "returns true when tasks are overdue" do
      create(:task, project: project, user: user, due_date: 1.day.ago)
      expect(project.overdue_tasks?).to be true
    end
  end

  describe "#find_user" do
    it "returns nil for blank user_id" do
      expect(project.find_user(nil)).to be_nil
    end

    it "returns the owner when user_id matches" do
      expect(project.find_user(user.id)).to eq(user)
    end

    it "returns a team member" do
      member = create(:user)
      project.users << member
      expect(project.find_user(member.id)).to eq(member)
    end

    it "returns nil for a non-member" do
      expect(project.find_user(create(:user).id)).to be_nil
    end
  end

  describe "#project_files_count_within_limit" do
    it "adds error when file count exceeds limit" do
      stub_const("Project::FILE_LIMIT", 0)
      project.project_files = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_file.txt'), 'text/plain')
      ]
      project.valid?
      expect(project.errors[:project_files]).to include("exceeds the limit of 0 files per project")
    end
  end

  describe "#create_sample_tasks" do
    it "returns false for unsaved project" do
      p = build(:project, user: user)
      expect(p.create_sample_tasks).to be false
    end

    it "returns false and logs error on RecordInvalid" do
      allow(project.tasks).to receive(:create).and_raise(ActiveRecord::RecordInvalid)
      expect(Rails.logger).to receive(:error).with(/Failed to create sample tasks/)
      expect(project.create_sample_tasks).to be false
    end
  end

  describe "#create_sample_links" do
    it "returns false for unsaved project" do
      p = build(:project, user: user)
      expect(p.create_sample_links).to be false
    end

    it "returns false and logs error on RecordInvalid" do
      allow(project.links).to receive(:create).and_raise(ActiveRecord::RecordInvalid)
      expect(Rails.logger).to receive(:error).with(/Failed to create sample links/)
      expect(project.create_sample_links).to be false
    end
  end

  describe "#add_activity" do
    let(:task) { create(:task, project: project, user: user) }

    it "does not create activity for personal projects" do
      personal = user.personal_project
      personal_task = create(:task, project: personal, user: user)
      expect {
        personal.add_activity(user, 'created', personal_task)
      }.not_to change(Activity, :count)
    end

    it "creates an activity record" do
      expect {
        project.add_activity(user, 'created', task)
      }.to change(project.activities, :count).by(1)
    end

    it "deletes oldest activities when at the limit" do
      stub_const("Project::ACTIVITY_LIMIT", 2)
      project.add_activity(user, 'created', task)
      project.add_activity(user, 'updated', task)
      oldest_id = project.activities.order(id: :asc).first.id

      project.add_activity(user, 'closed', task)

      expect(project.activities.count).to eq(2)
      expect(Activity.find_by(id: oldest_id)).to be_nil
    end

    it "returns false and logs error on RecordInvalid" do
      allow_any_instance_of(Activity).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
      expect(Rails.logger).to receive(:error).with(/Failed to add activity/)
      expect(project.add_activity(user, 'created', task)).to be false
    end
  end
end
