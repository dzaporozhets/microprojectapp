require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#time_ago_short' do
    it 'returns "now" for times less than a minute ago' do
      expect(helper.time_ago_short(Time.current)).to eq('now')
    end

    it 'returns 3 hours without about' do
      time = 3.hours.ago
      expect(helper.time_ago_short(time)).to eq('3 hours')
    end

    it 'returns 1 hour without about' do
      time = 45.minutes.ago
      expect(helper.time_ago_short(time)).to eq('1 hour')
    end

    it 'returns nil if time is nil' do
      expect(helper.time_ago_short(nil)).to be_nil
    end
  end
end
