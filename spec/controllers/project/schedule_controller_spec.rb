require 'rails_helper'

RSpec.describe Project::ScheduleController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  
  before do
    sign_in user
  end

  describe "GET #saturate" do
    context "when there are tasks without due dates" do
      it "assigns due dates to up to 5 tasks without due dates" do
        # Freeze time to ensure consistent date ranges
        travel_to Time.zone.local(2025, 3, 15) do
          # Create test tasks within the frozen time context
          tasks_without_due_date = create_list(:task, 7, project: project, user: user, due_date: nil, done: false)
          starred_task = create(:task, project: project, user: user, due_date: nil, done: false, star: true)
          done_task = create(:task, project: project, user: user, due_date: nil, done: true)
          task_with_due_date = create(:task, project: project, user: user, due_date: Date.current, done: false)
          expect {
            get :saturate, params: { project_id: project.id }
          }.to change { project.tasks.todo.no_due_date.count }.by(-5)
          
          # Verify that 5 tasks were updated with due dates
          # Note: We need to check specifically for tasks that were updated by the action
          # (excluding the task that already had a due date)
          newly_updated_tasks = project.tasks.todo.with_due_date.where(due_date: Date.current..Date.current.end_of_month)
          expect(newly_updated_tasks.count).to eq(6) # 5 newly updated + 1 that already had a due date
          
          # Verify that the starred task was prioritized
          expect(starred_task.reload.due_date).not_to be_nil
          
          # Verify that done tasks were not affected
          expect(done_task.reload.due_date).to be_nil
          
          # Verify that tasks with existing due dates were not affected
          expect(task_with_due_date.reload.due_date).to eq(Date.current)
          
          # Verify that all assigned due dates are within the current month
          newly_updated_tasks.each do |task|
            expect(task.due_date).to be_between(Date.current, Date.current.end_of_month)
          end
          
          # Verify redirect
          expect(response).to redirect_to(project_schedule_path(project))
        end
      end
    end
    
    context "when there are fewer than 5 tasks without due dates" do
      it "assigns due dates to all available tasks without due dates" do
        travel_to Time.zone.local(2025, 3, 15) do
          # Create test tasks within the frozen time context
          tasks_without_due_date = create_list(:task, 3, project: project, user: user, due_date: nil, done: false)
          
          expect {
            get :saturate, params: { project_id: project.id }
          }.to change { project.tasks.todo.no_due_date.count }.by(-3)
          
          # Verify that all 3 tasks now have due dates
          updated_tasks = project.tasks.todo.with_due_date
          expect(updated_tasks.count).to eq(3)
          
          # Verify that all assigned due dates are within the current month
          updated_tasks.each do |task|
            expect(task.due_date).to be_between(Date.current, Date.current.end_of_month)
          end
          
          # Verify redirect
          expect(response).to redirect_to(project_schedule_path(project))
        end
      end
    end
    
    context "when there are no tasks without due dates" do
      it "does not change any tasks" do
        travel_to Time.zone.local(2025, 3, 15) do
          expect {
            get :saturate, params: { project_id: project.id }
          }.not_to change { project.tasks.todo.no_due_date.count }
          
          # Verify redirect
          expect(response).to redirect_to(project_schedule_path(project))
        end
      end
    end
  end
end