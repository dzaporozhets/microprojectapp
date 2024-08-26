require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { create(:user) }

  let!(:project1) { create(:project, user: user) }
  let!(:project2) { create(:project) }
  let!(:project3) { create(:project) } # User is not involved with this project
  let!(:task1) { create(:task, project: project1) }
  let!(:task2) { create(:task, project: project2) }
  let!(:task3) { create(:task, project: project3) } # Task from a project user is not part of

  before do
    project2.users << user

    sign_in user
  end

  scenario "user views the tasks list" do
    visit tasks_path

    within('.task-list') do
      expect(page).to have_content(task1.name)
      expect(page).to have_content(task2.name)
      expect(page).not_to have_content(task3.name) # Task from project user is not involved with should not be shown
    end
  end
end
