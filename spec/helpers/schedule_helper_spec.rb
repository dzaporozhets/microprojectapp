require 'rails_helper'

RSpec.describe ScheduleHelper, type: :helper do
  describe '#due_date_options' do
    it 'includes "No Due Date" option' do
      options = helper.due_date_options
      expect(options).to include(['No Due Date', nil])
    end

    it 'includes "Tomorrow" option' do
      options = helper.due_date_options
      expect(options).to include(["Tomorrow (+1 day)", 1.day.from_now.to_date])
    end

    it 'includes "Monday" option' do
      days_until_monday = (1 - Date.today.wday) % 7
      days_until_monday = 7 if days_until_monday == 0
      next_monday = Date.today + days_until_monday
      options = helper.due_date_options
      expect(options).to include(["Monday (+#{days_until_monday} days)", next_monday])
    end

    it 'includes "End of the Week" option' do
      end_of_week = Date.today.end_of_week
      days_until_end_of_week = (end_of_week - Date.today).to_i
      options = helper.due_date_options
      expect(options).to include(["End of the Week (+#{days_until_end_of_week} days)", end_of_week])
    end

    it 'includes "End of the Month" option' do
      end_of_month = Date.today.end_of_month
      days_until_end_of_month = (end_of_month - Date.today).to_i
      options = helper.due_date_options
      expect(options).to include(["End of the Month (+#{days_until_end_of_month} days)", end_of_month])
    end

    it 'includes "End of the Year" option' do
      end_of_year = Date.today.end_of_year
      days_until_end_of_year = (end_of_year - Date.today).to_i
      options = helper.due_date_options
      expect(options).to include(["End of the Year (+#{days_until_end_of_year} days)", end_of_year])
    end

    it 'includes "Two Weeks from Now" option' do
      two_weeks_from_now = 2.weeks.from_now.to_date
      options = helper.due_date_options
      expect(options).to include(["Two Weeks from Now (+14 days)", two_weeks_from_now])
    end

    it 'prepends existing due date if provided' do
      existing_due_date = 10.days.from_now.to_date
      human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
      days_difference = (existing_due_date.to_date - Date.today).to_i
      options = helper.due_date_options(existing_due_date)
      expect(options.first).to eq(["#{human_readable_date} (+#{days_difference} days)", existing_due_date])
    end

    context 'when current week includes the next month' do
      it 'includes correct options' do
        # Set today is a Monday
        today = Date.new(2024, 7, 29)
        allow(Date).to receive(:today).and_return(today)

        # Next month is 3 days away
        wednesday = today + 2.days
        end_of_week = today.end_of_week

        options = helper.due_date_options

        expect(options).to include(["Monday (+7 days)", today + 7.days])
        expect(options).to include(["End of the Week (+6 days)", end_of_week])
        expect(options).to include(["End of the Month (+2 days)", wednesday])
      end
    end
  end
end
