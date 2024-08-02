require 'rails_helper'

RSpec.feature "Project::Export", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
    create(:task, project: project, name: "Task 1", done: false)
    create(:task, project: project, name: "Task 2", done: true)
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
  end
end
