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

    context "note activity" do
      let(:note) { create(:note, project: project, user: user, title: "Test note") }
      let(:activity_note) { create(:activity, trackable: note, user: user, action: "created", project: project) }

      it "returns a link to the note" do
        result = helper.record_to_text(activity_note)
        expect(result).to include("created")
        expect(result).to include("the note")
        expect(result).to include(project_note_path(project, note))
      end

      it "returns fallback text when note is deleted" do
        activity_note
        note.destroy!
        activity_note.reload

        expect(helper.record_to_text(activity_note)).to eq("created a note")
      end
    end
  end
end
