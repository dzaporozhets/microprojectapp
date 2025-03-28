require 'rails_helper'

RSpec.describe ScheduleHelper, type: :helper do
  around do |spec|
    travel_to Date.new(2024, 7, 12) do
      spec.run
    end
  end

  describe "#calendar_url" do
    let(:user) { create(:user) }

    before do
      # Mock request object
      allow(helper).to receive(:request).and_return(
        double("Request", host_with_port: "example.com")
      )
    end

    it "returns nil when user is nil" do
      expect(helper.calendar_url(nil)).to be_nil
    end

    it "returns nil when user has no calendar token" do
      allow(user).to receive(:calendar_token).and_return(nil)
      expect(helper.calendar_url(user)).to be_nil
    end

    it "returns a properly formatted calendar URL" do
      url = helper.calendar_url(user)

      expect(url).to include("http://example.com/schedule/calendar")
      expect(url).to include("token=#{user.calendar_token}")
      expect(url).to include(".ics?")
    end

    it "uses the provided host when specified" do
      url = helper.calendar_url(user, "custom-host.com")

      expect(url).to include("http://custom-host.com/schedule/calendar")
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

    it 'includes "Next month" option' do
      options = helper.due_date_options
      expect(options).to include(["Next month (Aug 12)", Date.new(2024, 8, 12)])
    end

    it 'includes two months from now option' do
      options = helper.due_date_options
      expect(options).to include(["September", Date.new(2024, 9, 1)])
    end

    it 'includes three months from now option' do
      options = helper.due_date_options
      expect(options).to include(["October", Date.new(2024, 10, 1)])
    end

    it 'prepends existing due date if provided' do
      existing_due_date = Date.new(2024, 7, 22)
      human_readable_date = I18n.l(existing_due_date, format: :long)
      options = helper.due_date_options(existing_due_date)

      expect(options.first).to eq([human_readable_date, existing_due_date])
    end
  end
end
