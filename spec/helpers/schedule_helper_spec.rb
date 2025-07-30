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


end
