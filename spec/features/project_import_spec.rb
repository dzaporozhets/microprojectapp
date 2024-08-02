require 'rails_helper'

RSpec.feature "Project::Import", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:file_path) { Rails.root.join('spec/fixtures/files/tasks.json') }

  before do
    sign_in user

    tasks = [
      { name: "Imported Task 1", description: "Description 1", due_date: "2024-07-24", done: false },
      { name: "Imported Task 2", description: "Description 2", due_date: "2024-07-25", done: true }
    ]

    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks }.to_json)
    end
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  scenario "User imports tasks from JSON" do
    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Import Tasks'

    expect(page).to have_content('Tasks Imported Successfully')
    expect(page).to have_content('Imported Task 1')
    expect(page).to have_content('Imported Task 2')
    expect(project.tasks.count).to eq(2)
    expect(project.tasks.pluck(:name)).to include("Imported Task 1", "Imported Task 2")
  end

  scenario "User tries to import tasks with an invalid JSON file" do
    invalid_file_path = Rails.root.join('spec/fixtures/files/invalid_tasks.json')
    File.open(invalid_file_path, 'w') { |f| f.write('Invalid JSON') }

    visit new_project_import_path(project)
    attach_file('file', invalid_file_path)
    click_button 'Import Tasks'

    expect(page).to have_content('Invalid JSON file.')
    File.delete(invalid_file_path) if File.exist?(invalid_file_path)
  end

  scenario "User tries to import tasks with a file exceeding size limit" do
    large_file_path = Rails.root.join('spec/fixtures/files/large_tasks.json')
    large_content = { project_name: project.name, tasks: Array.new(100_000) { { name: "Task", description: "Description", due_date: "2024-07-24", done: false } } }.to_json

    File.open(large_file_path, 'w') { |f| f.write(large_content) }

    visit new_project_import_path(project)
    attach_file('file', large_file_path)
    click_button 'Import Tasks'

    expect(page).to have_content('File size should be less than 5 MB.')
    File.delete(large_file_path) if File.exist?(large_file_path)
  end
end
