require 'rails_helper'

RSpec.describe "Schedule", type: :request do
  include Devise::Test::IntegrationHelpers
  describe "GET /schedule/calendar" do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    
    before do
      # Ensure user has a calendar token
      user.regenerate_calendar_token!
      
      # Create some tasks with due dates
      create(:task, project: project, user: user, due_date: Date.current)
      create(:task, project: project, user: user, due_date: 1.week.from_now)
      
      # Create a task without a due date (should not be included)
      create(:task, project: project, user: user, due_date: nil)
      
      # Create a completed task with due date (should not be included)
      create(:task, project: project, user: user, due_date: Date.current, done: true)
    end

    context "without a token" do
      it "returns unauthorized" do
        get calendar_schedule_path(format: :ics)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an invalid token" do
      it "returns unauthorized" do
        get calendar_schedule_path(token: "invalid_token", format: :ics)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with a valid token" do
      it "returns a valid iCalendar file" do
        get calendar_schedule_path(token: user.calendar_token, format: :ics)
        
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include("text/calendar")
        
        # Basic validation of iCalendar format
        expect(response.body).to include("BEGIN:VCALENDAR")
        expect(response.body).to include("END:VCALENDAR")
        
        # Should include the two tasks with due dates that are not completed
        expect(response.body.scan("BEGIN:VEVENT").size).to eq(2)
      end
    end
  end

  describe "POST /users/settings/regenerate_calendar_token" do
    let(:user) { create(:user) }
    
    before do
      sign_in user
    end

    it "regenerates the user's calendar token" do
      original_token = user.calendar_token
      
      post regenerate_calendar_token_users_settings_path
      
      expect(response).to redirect_to(users_settings_path)
      expect(flash[:notice]).to include("Calendar token has been regenerated")
      
      # Reload user to get the updated token
      user.reload
      expect(user.calendar_token).not_to eq(original_token)
    end
  end
end