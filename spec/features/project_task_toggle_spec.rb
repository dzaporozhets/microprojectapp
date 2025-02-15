require 'rails_helper'

RSpec.feature 'Project::Task Toggle', type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project, user: user) }

  before do
    sign_in user
  end

  scenario 'marks a task as done', js: true do
    visit project_path(project)

    within "#task_#{task.id}" do
      find('input[name="task[done]"]').click
    end

    within('#completed_tasks') do
      expect(page).to have_content(task.name)
    end

    expect(task.reload.done).to be(true)
  end

  scenario 'marks a task as not done', js: true do
    task.update(done: true)

    visit project_path(project)

    within "#task_#{task.id}" do
      find('input[name="task[done]"]').click
    end

    within('#tasks') do
      expect(page).not_to have_content('Completed')
    end

    expect(task.reload.done).to be(false)
  end

  scenario 'marks a task as starred' do
    visit project_path(project)
    click_link task.name
    click_link 'Star'

    expect(task.reload.star).to be(true)
  end

  scenario 'marks a task as not starred' do
    task.update(star: true)

    visit project_path(project)
    click_link task.name
    click_link 'Star'

    expect(task.reload.star).to be(false)
  end
end
