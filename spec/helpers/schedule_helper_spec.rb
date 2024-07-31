require 'rails_helper'

RSpec.describe ScheduleHelper, type: :helper do
  around(:each) do |spec|
    travel_to Date.new(2024, 7, 12) do
      spec.run
    end
  end

  describe '#due_date_options' do
    it 'includes "No Due Date" option' do
      options = helper.due_date_options
      expect(options).to include(['No Due Date', nil])
    end

    it 'includes "Tomorrow" option' do
      options = helper.due_date_options
      expect(options).to include(["Tomorrow (Jul 13)", Date.new(2024, 7, 13)])
    end

    it 'includes "Monday" option' do
      options = helper.due_date_options
      expect(options).to include(["Monday (Jul 15)", Date.new(2024, 7, 15)])
    end

    it 'includes "In Two Weeks" option' do
      options = helper.due_date_options
      expect(options).to include(["In Two Weeks (Jul 26)", Date.new(2024, 7, 26)])
    end

    it 'includes "In Four Weeks" option' do
      options = helper.due_date_options
      expect(options).to include(["In Four Weeks (Aug 09)", Date.new(2024, 8, 9)])
    end

    it 'prepends existing due date if provided' do
      existing_due_date = Date.new(2024, 7, 22)
      human_readable_date = I18n.l(existing_due_date, format: :long)
      options = helper.due_date_options(existing_due_date)

      expect(options.first).to eq([human_readable_date, existing_due_date])
    end
  end
end
