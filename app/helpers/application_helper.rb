module ApplicationHelper
  def formatted_date(date)
    day_with_ordinal = date.day.ordinalize
    date.strftime("%A, #{day_with_ordinal}")
  end

  def gravatar_tag(email, css_class = '', options = { size: 40, alt: 'Gravatar' })
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    size = options[:size]
    alt = options[:alt]
    gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: alt, class: "gravatar #{css_class}")
  end

  def flash_css(type)
    case type.to_sym
    when :notice then 'bg-blue-100 border rounded border-blue-500 text-blue-700'
    when :alert then 'bg-red-100 border rounded border-red-500 text-red-700'
    else 'bg-gray-100 border rounded border-gray-500 text-gray-700'
    end
  end
end
