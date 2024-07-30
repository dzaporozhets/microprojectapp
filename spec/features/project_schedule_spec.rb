require 'rails_helper'

RSpec.feature "Project Schedule", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User visits the schedule page and sees tasks categorized correctly" do
    travel_to Date.new(2024, 7, 12) do
      past_task = create(:task, name: "Past Task", due_date: Date.current - 1.day, project: project, user: user)
      today_task = create(:task, name: "Today Task", due_date: Date.current, project: project, user: user)
      tomorrow_task = create(:task, name: "Tomorrow Task", due_date: Date.current + 1.day, project: project, user: user)
      end_of_month_task = create(:task, name: "End of Month Task", due_date: Date.current.end_of_month, project: project, user: user)
      next_month_task = create(:task, name: "Next Month Task", due_date: Date.current.next_month.beginning_of_month, project: project, user: user)
      month_after_next_task = create(:task, name: "Month After Next Task", due_date: Date.current.next_month.next_month.beginning_of_month, project: project, user: user)

      visit project_schedule_path(project)

      within("section", text: Date.current.strftime("%B")) do
        expect(page).to have_content("Past Task")
        expect(page).to have_content("Today Task")
        expect(page).to have_content("Tomorrow Task")
        expect(page).to have_content("End of Month Task")
        expect(page).not_to have_content("Next Month Task")
      end

      within("section", text: Date.current.next_month.strftime("%B")) do
        expect(page).to have_content("Next Month Task")
        expect(page).not_to have_content("End of Month Task")
        expect(page).not_to have_content("Month After Next Task")
      end

      within("section", text: Date.current.next_month.next_month.strftime("%B")) do
        expect(page).to have_content("Month After Next Task")
        expect(page).not_to have_content("Next Month Task")
      end
    end
  end
end
