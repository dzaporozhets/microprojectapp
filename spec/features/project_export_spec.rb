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

  scenario "User clicks export button and downloads tasks with comments" do
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

  scenario "User exports empty project" do
    empty_project = create(:project, user: user, name: "Empty Project")

    visit edit_project_path(empty_project)

    click_button 'Export Tasks'

    json = JSON.parse(page.body)

    expect(json['project_name']).to eq("Empty Project")
    expect(json['tasks']).to be_empty
    expect(json['notes']).to be_empty
  end

  scenario "User exports project with notes" do
    create(:note, project: project, user: user, title: "Important Note", content: "Note content")

    visit edit_project_path(project)

    click_button 'Export Tasks'

    json = JSON.parse(page.body)

    expect(json['notes'].size).to eq(1)
    expect(json['notes'][0]['title']).to eq("Important Note")
    expect(json['notes'][0]['content']).to eq("Note content")
  end

  scenario "Non-owner cannot export project" do
    other_user = create(:user)
    sign_in other_user

    visit edit_project_path(project)

    expect(page).to have_content("The page you were looking for doesn't exist")
  end
end
