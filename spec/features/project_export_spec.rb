require 'rails_helper'

RSpec.feature "Project::Export", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task_one) { create(:task, project: project, user: user, name: "Task 1", done: false) }
  let!(:task_two) { create(:task, project: project, user: user, name: "Task 2", done: true) }
  let!(:comment) { create(:comment, task: task_one, user: user, body: "Remember to test") }

  before do
    sign_in user
  end

  scenario "User exports tasks to JSON" do
    visit edit_project_path(project)

    click_button 'Export Tasks'

    expect(page.response_headers['Content-Type']).to eq 'application/json'
    expect(page.response_headers['Content-Disposition']).to include("attachment; filename=\"microprojectapp-")

    json = JSON.parse(page.body)

    expect(json['project_name']).to eq(project.name)
    expect(json['tasks'].size).to eq(2)
    expect(json['tasks'][0]['name']).to eq("Task 1")
    expect(json['tasks'][1]['name']).to eq("Task 2")
    expect(json['tasks'][0]['comments']).to contain_exactly(
      hash_including('body' => comment.body, 'user_email' => user.email)
    )
  end
end
