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

    it 'includes "Two Weeks from Now" option' do
      two_weeks_from_now = 2.weeks.from_now.to_date
      options = helper.due_date_options
      expect(options).to include(["Two Weeks from Now (+14 days)", two_weeks_from_now])
    end

    it 'includes "Four Weeks from Now" option' do
      options = helper.due_date_options
      expect(options).to include(["Four Weeks from Now (+28 days)", 4.weeks.from_now.to_date])
    end

    it 'prepends existing due date if provided' do
      existing_due_date = 10.days.from_now.to_date
      human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
      days_difference = (existing_due_date.to_date - Date.today).to_i
      options = helper.due_date_options(existing_due_date)
      expect(options.first).to eq(["#{human_readable_date} (+#{days_difference} days)", existing_due_date])
    end
  end
end
