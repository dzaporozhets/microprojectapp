require 'rails_helper'

RSpec.feature "Task Comments", type: :feature do
  let(:user) { create(:user) }
  let(:project) { user.personal_project }
  let(:task) { create(:task, project: project, user: user) }

  before do
    sign_in user
  end

  scenario 'User adds a new comment to a task' do
    visit details_project_task_path(project, task)

    fill_in 'comment_body', with: 'This is a test comment'
    click_button 'Comment'

    expect(page).to have_content('This is a test comment')
    expect(page).to have_content(user.email)
  end

  scenario 'User sees existing comments on task' do
    create(:comment, task: task, user: user, body: 'Existing comment')

    visit details_project_task_path(project, task)

    expect(page).to have_content('Existing comment')
    expect(page).to have_content(user.email)
  end
end

