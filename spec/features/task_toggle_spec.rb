require 'rails_helper'

RSpec.feature 'Task Toggle', type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project, user: user, due_date: Date.current) }

  before do
    sign_in user
  end

  scenario 'marks a task as done from tasks page', :js do
    visit tasks_path

    expect(page).to have_content(task.name)

    find('input[name="task[done]"]').click

    within('.task-list') do
      expect(page).not_to have_content(task.name)
    end

    expect(task.reload.done).to be(true)
    expect(page).to have_current_path(tasks_path)
  end
end
