require 'rails_helper'

RSpec.describe TaskNameParser do
  describe '.parse' do
    around do |example|
      travel_to Date.new(2026, 3, 18) do # Wednesday
        example.run
      end
    end

    it 'returns today for "Buy groceries today"' do
      expect(described_class.parse('Buy groceries today')).to eq(Date.new(2026, 3, 18))
    end

    it 'returns tomorrow for "Buy groceries tomorrow"' do
      expect(described_class.parse('Buy groceries tomorrow')).to eq(Date.new(2026, 3, 19))
    end

    it 'returns next Monday for "Do laundry next week"' do
      expect(described_class.parse('Do laundry next week')).to eq(Date.new(2026, 3, 23))
    end

    context 'with day names' do
      it 'returns next occurrence of that day' do
        # Today is Wednesday, so "friday" => this Friday
        expect(described_class.parse('Call dentist friday')).to eq(Date.new(2026, 3, 20))
      end

      it 'returns today if the day name matches today' do
        # Today is Wednesday
        expect(described_class.parse('Fix roof wednesday')).to eq(Date.new(2026, 3, 18))
      end

      it 'returns next occurrence for a past day this week' do
        # Today is Wednesday, "monday" => next Monday
        expect(described_class.parse('Review PR monday')).to eq(Date.new(2026, 3, 23))
      end
    end

    context 'with "next <day>" patterns' do
      it 'returns the named day in the following week' do
        # Today is Wednesday, "next friday" => Friday of next week
        expect(described_class.parse('Deploy next friday')).to eq(Date.new(2026, 3, 27))
      end

      it 'returns the named day in the following week even for today\'s day' do
        # Today is Wednesday, "next wednesday" => next Wednesday
        expect(described_class.parse('Meeting next wednesday')).to eq(Date.new(2026, 3, 25))
      end

      it 'returns next monday for "next monday"' do
        # Today is Wednesday, "next monday" => Monday of next week
        expect(described_class.parse('Sync next monday')).to eq(Date.new(2026, 3, 30))
      end
    end

    it 'is case insensitive' do
      expect(described_class.parse('Buy groceries TODAY')).to eq(Date.new(2026, 3, 18))
      expect(described_class.parse('Buy groceries Tomorrow')).to eq(Date.new(2026, 3, 19))
      expect(described_class.parse('Buy groceries NEXT WEEK')).to eq(Date.new(2026, 3, 23))
      expect(described_class.parse('Buy groceries Friday')).to eq(Date.new(2026, 3, 20))
      expect(described_class.parse('Buy groceries Next Friday')).to eq(Date.new(2026, 3, 27))
    end

    it 'returns nil for names with no date pattern' do
      expect(described_class.parse('Buy groceries')).to be_nil
      expect(described_class.parse('Fix the bug')).to be_nil
    end

    it 'returns nil when pattern is in the middle of the name' do
      expect(described_class.parse('tomorrow buy groceries')).to be_nil
      expect(described_class.parse('today is a good day')).to be_nil
    end

    it 'returns nil for blank input' do
      expect(described_class.parse(nil)).to be_nil
      expect(described_class.parse('')).to be_nil
    end
  end
end
