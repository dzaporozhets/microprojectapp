require 'rails_helper'

RSpec.feature "Project Schedule", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario "User visits the schedule page and sees tasks categorized correctly" do
    # Create tasks with different due dates
    past_task = create(:task, name: "Past Task", due_date: Date.current - 1.day, project: project, user: user)
    today_task = create(:task, name: "Today Task", due_date: Date.current, project: project, user: user)
    tomorrow_task = create(:task, name: "Tomorrow Task", due_date: Date.current + 1.day, project: project, user: user)
    end_of_week_task = create(:task, name: "End of Week Task", due_date: Date.current.end_of_week, project: project, user: user)
    next_week_task = create(:task, name: "Next Week Task", due_date: Date.current.next_week.beginning_of_week, project: project, user: user)
    end_of_month_task = create(:task, name: "End of Month Task", due_date: Date.current.end_of_month, project: project, user: user)
    next_month_task = create(:task, name: "Next Month Task", due_date: Date.current.next_month.beginning_of_month, project: project, user: user)
    end_of_year_task = create(:task, name: "End of Year Task", due_date: Date.current.end_of_year, project: project, user: user)

    visit project_schedule_path(project)

    within("section", text: "Today") do
      expect(page).to have_content("Past Task")
      expect(page).to have_content("Today Task")
      expect(page).not_to have_content("Tomorrow Task")
    end

    within("section", text: "This Week") do
      expect(page).to have_content("Tomorrow Task")
      expect(page).to have_content("End of Week Task")
      expect(page).not_to have_content("Next Week Task")
    end

    within("section", text: "This Month") do
      expect(page).to have_content("Next Week Task")
      expect(page).to have_content("End of Month Task")
      expect(page).not_to have_content("Next Month Task")
    end

    within("section", text: "This Year") do
      expect(page).to have_content("Next Month Task")
      expect(page).to have_content("End of Year Task")
    end
  end
end

