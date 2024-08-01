require 'rails_helper'

RSpec.describe ActivityHelper, type: :helper do
  describe "#record_to_text" do
    let(:user) { create(:user) }
    let(:user2) { create(:user, email: "user@example.com") }

    let(:project) { create(:project, user: user) }
    let(:task) { create(:task, project: project, user: user) }

    let(:activity_task) { create(:activity, trackable: task, user: user, action: "created", project: project) }
    let(:activity_user) { create(:activity, trackable: user2, user: user, action: "invited", project: project) }

    it "returns the correct text for a task activity" do
      expect(helper.record_to_text(activity_task)).to eq("created <a class=\"underline\" href=\"/projects/#{project.id}/tasks/#{task.id}/details\">the task</a>")
    end

    it "returns the correct text for a user activity" do
      expect(helper.record_to_text(activity_user)).to eq("invited user@example.com")
    end
  end
end
