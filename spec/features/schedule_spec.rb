require "rails_helper"

RSpec.feature "Schedule", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  let!(:past_task)     { create(:task, name: "Past Task", project: project, due_date: Date.new(2025, 2, 28)) }
  let!(:current_task1) { create(:task, name: "March Task 1", project: project, due_date: Date.new(2025, 3, 6)) }
  let!(:current_task2) { create(:task, name: "March Task 2", project: project, due_date: Date.new(2025, 3, 24)) }
  let!(:current_task3) { create(:task, name: "March Task 3", project: project, due_date: Date.new(2025, 3, 31)) }
  let!(:future_task)   { create(:task, name: "Future Task", project: project, due_date: Date.new(2025, 4, 24)) }

  before { sign_in user }

  scenario "shows March 2025 tasks correctly grouped" do
    visit schedule_path(date: "2025-03-01")

    within(".past-due-tasks") do
      expect(page).to have_content("Past Task")
    end

    within(".current-tasks") do
      expect(page).to have_content("March Task 1")
      expect(page).to have_content("March Task 2")
      expect(page).to have_content("March Task 3")
    end

    within(".upcoming-tasks") do
      expect(page).to have_content("Future Task")
    end
  end

  scenario "shows February 2025 tasks grouped properly" do
    visit schedule_path(date: "2025-02-01")

    within(".current-tasks") do
      expect(page).to have_content("Past Task")
    end

    expect(page).not_to have_selector(".past-due-tasks")

    within(".upcoming-tasks") do
      expect(page).to have_content("March Task 1")
      expect(page).to have_content("March Task 2")
      expect(page).to have_content("March Task 3")
      expect(page).to have_content("Future Task")
    end
  end

  scenario "shows April 2025 tasks grouped properly" do
    visit schedule_path(date: "2025-04-01")

    within(".current-tasks") do
      expect(page).to have_content("Future Task")
    end

    within(".past-due-tasks") do
      expect(page).to have_content("March Task 1")
      expect(page).to have_content("March Task 2")
      expect(page).to have_content("March Task 3")
      expect(page).to have_content("Past Task")
    end

    expect(page).not_to have_selector(".upcoming-tasks")
  end

  scenario "shows empty state when no tasks exist" do
    Task.delete_all
    visit schedule_path(date: "2025-03-01")

    expect(page).not_to have_selector(".past-due-tasks")
    expect(page).not_to have_selector(".current-tasks")
    expect(page).not_to have_selector(".upcoming-tasks")
  end
end
