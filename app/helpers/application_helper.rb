module ApplicationHelper
  def formatted_date(date)
    day_with_ordinal = date.day.ordinalize
    date.strftime("%A, #{day_with_ordinal}")
  end

  def gravatar_tag(email, css_class = '', options = { size: 40, width: nil, alt: 'Gravatar' })
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    size = options[:size]
    width = options[:width] || size
    alt = options[:alt]
    gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: alt, class: "gravatar #{css_class}", width: width)
  end

  def flash_css(type)
    case type.to_sym
    when :notice then 'bg-blue-50 border rounded border-blue-400 text-blue-700'
    when :alert then 'bg-red-50 border rounded border-red-400 text-red-700'
    else 'bg-gray-100 border rounded border-gray-500 text-gray-700'
    end
  end

  def current_page
    params[:page].to_i || 1
  end

  def time_ago_short(time)
    return unless time

    time_ago_in_words(time).gsub('less than a minute', 'now')
      .gsub('about ', '')
  end

  def render_tabs(tabs, selected = nil)
    content_tag(:nav, class: 'flex space-x-3', aria: { label: 'Tabs' }) do
      tabs.map do |tab|
        current_tab = selected == tab[:name]

        link_class = 'rounded-md px-4 py-2 text-sm font-medium'
        link_class += current_tab ? ' bg-indigo-100 text-indigo-900' : ' text-gray-500 hover:text-gray-900'
        link_options = current_tab ? { 'aria-current' => 'page' } : {}

        link_to tab[:name], tab[:path], class: link_class, **link_options
      end.join.html_safe
    end
  end
end
