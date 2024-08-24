module ApplicationHelper
  def home_tabs(selected = nil)
    tabs = [
      { name: 'Projects', path: projects_path },
      { name: 'Schedule', path: schedule_path }
    ]

    render_tabs(tabs, selected)
  end

  def formatted_date(date)
    day_with_ordinal = date.day.ordinalize
    date.strftime("%A, #{day_with_ordinal}")
  end

  def avatar_tag(user, css_class = '', options = { size: 40, alt: 'Avatar' })
    if user.avatar_url.present?
      image_tag(user.avatar_url, class: "rounded-full #{css_class}", size: options[:size], alt: options[:alt])
    else
      first_letter = user.email[0].upcase
      size = options[:size]
      alt = options[:alt]
      style = ""

      content_tag(:div, first_letter, class: "flex items-center justify-center rounded-full #{css_class}", style: style, alt: alt)
    end
  end

  def flash_css(type)
    case type.to_sym
    when :notice then 'bg-indigo-50 border rounded border-indigo-400 text-indigo-700'
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
        link_class = current_tab ? 'btn-tab-active' : 'btn-tab'
        link_options = current_tab ? { 'aria-current' => 'page' } : {}
        link_to tab[:name], tab[:path], class: link_class, **link_options
      end.join.html_safe
    end
  end

  def dark_mode_class
    return unless current_user

    case current_user.dark_mode
    when 'on'
      'light'
    when 'off'
      'dark'
    else
      ''
    end
  end
end
