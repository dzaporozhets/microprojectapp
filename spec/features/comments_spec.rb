require 'rails_helper'

RSpec.feature "Task Comments", type: :feature do
  include ActionView::RecordIdentifier

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

  scenario 'User removes their own comment and sees a placeholder' do
    comment = create(:comment, task: task, user: user, body: 'Removable comment')

    visit details_project_task_path(project, task)
    expect(page).to have_content('Removable comment')

    within "##{dom_id(comment)}" do
      find('form button').click
    end

    expect(page).to have_content('This comment was removed.')
    expect(page).not_to have_content('Removable comment')
  end

  context "when file storage is enabled" do
    before do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        Rails.application.config.app_settings.merge(enable_local_file_storage: true)
      )
    end

    scenario 'Attachment field is visible in comment form' do
      visit details_project_task_path(project, task)

      expect(page).to have_field('comment[attachment]')
    end
  end

  context "when file storage is disabled" do
    before do
      allow(Rails.application.config).to receive(:app_settings).and_return(
        Rails.application.config.app_settings.merge(
          aws_s3_bucket: nil,
          enable_local_file_storage: false
        )
      )
    end

    scenario 'Attachment field is hidden in comment form' do
      visit details_project_task_path(project, task)

      expect(page).not_to have_field('comment[attachment]')
    end
  end
end
