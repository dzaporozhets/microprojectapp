class TaskNameParser
  DAY_NAMES = %w[sunday monday tuesday wednesday thursday friday saturday].freeze

  def self.parse(name)
    return nil if name.blank?

    today = Date.current

    case name.strip
    when /\s+today$/i
      today
    when /\s+tomorrow$/i
      today + 1
    when /\s+next\s+week$/i
      days_until_monday = (1 - today.wday) % 7
      today + (days_until_monday.zero? ? 7 : days_until_monday)
    when /\s+next\s+(#{DAY_NAMES.join('|')})$/i
      target_day = DAY_NAMES.index($1.downcase)
      days_ahead = (target_day - today.wday) % 7
      today + days_ahead + 7
    when /\s+(#{DAY_NAMES.join('|')})$/i
      target_day = DAY_NAMES.index($1.downcase)
      days_ahead = (target_day - today.wday) % 7
      today + days_ahead
    end
  end
end
