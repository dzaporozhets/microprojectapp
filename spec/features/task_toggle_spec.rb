require 'rails_helper'

RSpec.feature 'Task Toggle', type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project, user: user) }

  before do
    sign_in user
  end

  scenario 'marks a task as done from tasks page', :js do
    visit tasks_path

    expect(page).to have_content(task.name)

    first('input[name="task[done]"]').click

    expect(page).not_to have_content(task.name)
    expect(task.reload.done).to be(true)
    expect(page).to have_current_path(tasks_path)
  end
end
