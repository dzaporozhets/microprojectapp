require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, user: user, project: project) }
  let(:done_task) { create(:task, user: user, project: project, done: true) }

  describe "associations" do
    it { is_expected.to belong_to(:project).required(true) }
    it { is_expected.to belong_to(:user).required(true) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

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
    describe ".todo" do
      it "returns tasks that are not done" do
        task
        done_task

        expect(Task.todo).to include(task)
        expect(Task.todo).not_to include(done_task)
      end
    end

    describe ".done" do
      it "returns tasks that are done" do
        task
        done_task

        expect(Task.done).to include(done_task)
        expect(Task.done).not_to include(task)
      end
    end

    describe ".order_by_star_then_old" do
      let!(:task1) { create(:task, user: user, project: project, star: false, created_at: 3.days.ago) }
      let!(:task2) { create(:task, user: user, project: project, star: false, created_at: 2.day.ago) }
      let!(:task3) { create(:task, user: user, project: project, star: true, created_at: 1.day.ago) }

      it "orders by star in descending order and then by created_at in ascending order" do
        expect(Task.order_by_star_then_old).to eq([task3, task1, task2])
      end
    end
  end

  describe 'callbacks' do
    it 'sets done_at when done changes to true' do
      expect(task.done_at).to be_nil

      task.update(done: true)

      expect(task.done_at).not_to be_nil
    end

    it 'does not change done_at if done is false' do
      task = create(:task, user: user, project: project, done: false)
      task.update(done: false)

      expect(task.done_at).to be_nil
    end
  end

  describe '.group_by_projects' do
    let!(:project_a) { create(:project, name: 'Project A') }
    let!(:project_b) { create(:project, name: 'Project B') }
    let!(:project_c) { create(:project, name: 'Project C') }
    let!(:task1) { create(:task, project: project_b) }
    let!(:task2) { create(:task, project: project_a) }
    let!(:task3) { create(:task, project: project_c) }
    let!(:task4) { create(:task, project: project_a) }

    it 'groups tasks by project and sorts by project name' do
      grouped_tasks = Task.all.group_by_projects

      expect(grouped_tasks.map(&:first)).to eq([project_a, project_b, project_c])
      expect(grouped_tasks[0].last).to contain_exactly(task2, task4)
      expect(grouped_tasks[1].last).to contain_exactly(task1)
      expect(grouped_tasks[2].last).to contain_exactly(task3)
    end
  end
end
