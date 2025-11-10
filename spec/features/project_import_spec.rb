require 'rails_helper'

RSpec.feature "Project::Import", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:file_path) { Rails.root.join('spec/fixtures/files/tasks.json') }

  before do
    sign_in user
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  scenario "User imports tasks from JSON" do
    tasks = [
      { name: "Imported Task 1", description: "Description 1", due_date: "2024-07-24", done: false },
      { name: "Imported Task 2", description: "Description 2", due_date: "2024-07-25", done: true }
    ]

    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content('Successfully imported 2 tasks, 0 notes, and 0 comments into the project')
    expect(page).to have_content('Imported Task 1')
    expect(page).to have_content('Imported Task 2')
    expect(project.tasks.count).to eq(2)
    expect(project.tasks.pluck(:name)).to include("Imported Task 1", "Imported Task 2")
  end

  scenario "User imports tasks and notes from JSON" do
    tasks = [
      { name: "Imported Task 1", description: "Task 1", due_date: "2024-07-24", done: false }
    ]
    notes = [
      { title: "Note 1", content: "Content 1" },
      { title: "Note 2", content: "Content 2" }
    ]

    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks, notes: notes }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content('Successfully imported 1 tasks, 2 notes, and 0 comments into the project')
    expect(project.tasks.count).to eq(1)
    expect(project.notes.count).to eq(2)
  end

  scenario "User tries to import tasks with an invalid JSON file" do
    invalid_file_path = Rails.root.join('spec/fixtures/files/invalid_tasks.json')
    File.open(invalid_file_path, 'w') { |f| f.write('Invalid JSON') }

    visit new_project_import_path(project)
    attach_file('file', invalid_file_path)
    click_button 'Upload file'

    expect(page).to have_content('Invalid JSON file.')
    File.delete(invalid_file_path) if File.exist?(invalid_file_path)
  end

  scenario "User tries to import tasks with a file exceeding size limit" do
    large_file_path = Rails.root.join('spec/fixtures/files/large_tasks.json')
    # Create a file with many tasks to exceed MAX_FILE_SIZE (adjust the multiplier as needed)
    large_content = { project_name: project.name, tasks: Array.new(100_000) { { name: "Task", description: "Description", due_date: "2024-07-24", done: false } } }.to_json

    File.open(large_file_path, 'w') { |f| f.write(large_content) }

    visit new_project_import_path(project)
    attach_file('file', large_file_path)
    click_button 'Upload file'

    expect(page).to have_content('File size should be less than')
    File.delete(large_file_path) if File.exist?(large_file_path)
  end

  scenario "User tries to import JSON with tasks not as an array" do
    # Here, tasks is provided as an object instead of an array.
    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: { name: "Task", description: "Desc" } }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content('Invalid JSON file format: tasks should be an array.')
  end

  scenario "User tries to import JSON with notes not as an array" do
    tasks = [
      { name: "Imported Task 1", description: "Description 1", due_date: "2024-07-24", done: false }
    ]
    # Notes provided as an object instead of an array.
    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks, notes: { title: "Note", content: "Content" } }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content('Invalid JSON file format: notes should be an array.')
  end

  scenario "User tries to import JSON with too many tasks" do
    stub_const("Task::TASK_LIMIT", 2)
    max_import_count = Task::TASK_LIMIT

    tasks = Array.new(max_import_count + 1) do |i|
      { name: "Task #{i}", description: "Desc", due_date: "2024-07-24", done: false }
    end

    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content("Too many tasks or notes. Maximum allowed is #{max_import_count} items each.")
  end

  scenario "User tries to import JSON with too many notes" do
    stub_const("Task::TASK_LIMIT", 2)
    max_import_count = Task::TASK_LIMIT

    notes = Array.new(max_import_count + 1) do |i|
      { title: "Note #{i}", content: "Content" }
    end
    tasks = [
      { name: "Imported Task 1", description: "Description 1", due_date: "2024-07-24", done: false }
    ]
    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks, notes: notes }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content("Too many tasks or notes. Maximum allowed is #{max_import_count} items each.")
  end

  scenario "User imports tasks with comments" do
    another_user = create(:user, email: 'commenter@example.com')
    tasks = [
      {
        name: "Imported Task 1",
        description: "Description 1",
        comments: [
          { body: "First comment", user_email: user.email },
          { body: "Second comment", user_email: another_user.email }
        ]
      }
    ]

    File.open(file_path, 'w') do |f|
      f.write({ project_name: project.name, tasks: tasks }.to_json)
    end

    visit new_project_import_path(project)
    attach_file('file', file_path)
    click_button 'Upload file'

    expect(page).to have_content('Successfully imported 1 tasks, 0 notes, and 2 comments into the project')
    imported_task = project.tasks.last
    expect(imported_task.comments.count).to eq(2)
    expect(imported_task.comments.pluck(:body)).to include("First comment", "Second comment")
    expect(imported_task.comments.pluck(:user_id)).to include(user.id, another_user.id)
  end
end
