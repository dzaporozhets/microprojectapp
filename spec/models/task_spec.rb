require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, user: user, project: project) }

  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:project_id) }

    describe "TASK_LIMIT" do
      it "does not allow creation of a task if the project already has the limit of tasks" do
        2.times { create(:task, project: project, user: user) }
        task = build(:task, project: project, user: user)

        stub_const("Task::TASK_LIMIT", 2)

        expect(task).not_to be_valid
        expect(task.errors[:base]).to include("This project has reached the limit of 2 tasks.")
      end
    end
  end

  describe "scopes" do
    before do
      @todo_task = create(:task, user: user, project: project, done: false)
      @done_task = create(:task, user: user, project: project, done: true)
    end

    it "returns tasks that are not done" do
      expect(Task.todo).to include(@todo_task)
      expect(Task.todo).not_to include(@done_task)
    end

    it "returns tasks that are done" do
      expect(Task.done).to include(@done_task)
      expect(Task.done).not_to include(@todo_task)
    end
  end
end
