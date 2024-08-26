require 'rails_helper'

RSpec.feature "Schedule", type: :feature do
  let(:user) { create(:user) }

  let!(:project1) { create(:project, user: user) }
  let!(:project2) { create(:project) }
  let!(:project3) { create(:project) } # User is not involved with this project
  let!(:task1) { create(:task, project: project1, due_date: Date.current) }
  let!(:task2) { create(:task, project: project2, due_date: Date.current.beginning_of_month + 5.days) }
  let!(:task3) { create(:task, project: project1, due_date: Date.current.end_of_month) }
  let!(:task4) { create(:task, project: project2, due_date: Date.current.next_month) }
  let!(:task5) { create(:task, project: project3, due_date: Date.current) } # Task from a project user is not part of

  before do
    project2.users << user

    sign_in user
  end

  scenario "user views the schedule for the current month" do
    visit schedule_path

    expect(page).to have_content(Date.current.strftime("%B %Y"))

    within('.task-list') do
      expect(page).to have_content(task1.name)
      expect(page).to have_content(task2.name)
      expect(page).to have_content(task3.name)
      expect(page).not_to have_content(task4.name)
      expect(page).not_to have_content(task5.name) # Task from project user is not involved with should not be shown
    end
  end

  scenario "user navigates to the previous month" do
    visit schedule_path

    within('.calendar') do
      click_link(class: 'prev-month')
    end

    expect(page).to have_content(Date.current.prev_month.strftime("%B %Y"))
    expect(page).not_to have_content(task1.name)
    expect(page).not_to have_content(task2.name)
    expect(page).not_to have_content(task3.name)
    expect(page).not_to have_content(task5.name) # Ensure task from unrelated project is not shown
  end

  scenario "user navigates to the next month" do
    visit schedule_path

    within('.calendar') do
      click_link(class: 'next-month')
    end

    expect(page).to have_content(Date.current.next_month.strftime("%B %Y"))
    expect(page).to have_content(task4.name)
    expect(page).not_to have_content(task1.name)
    expect(page).not_to have_content(task2.name)
    expect(page).not_to have_content(task3.name)
    expect(page).not_to have_content(task5.name) # Ensure task from unrelated project is not shown
  end

  scenario "user tries to view a non-existing date" do
    visit schedule_path(date: 'invalid-date')

    expect(page).to have_content(Date.current.strftime("%B %Y"))
  end

  scenario "user views a month with no tasks due" do
    Task.delete_all

    visit schedule_path

    expect(page).to have_content("No tasks due this month.")
  end
end
