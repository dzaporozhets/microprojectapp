module ApplicationHelper
  def home_tabs(selected = nil)
    tabs = [
      { name: 'Projects', path: projects_path },
      { name: 'Tasks', path: tasks_path }
    ]

    unless selected
      selected = 'Projects' if current_page?(projects_path)
      selected = 'Tasks' if current_page?(tasks_path)
    end

    render_tabs(tabs, selected)
  end

  def formatted_date(date)
    day_with_ordinal = date.day.ordinalize
    date.strftime("%A, #{day_with_ordinal}")
  end

  def avatar_tag(user, css_class = '', options = { size: 40, alt: 'Avatar' })
    if avatar_src(user).present?
      content_tag(:div, class: 'flex') do
        image_tag(avatar_src(user), class: "rounded-full #{css_class}", size: options[:size], alt: options[:alt])
      end
    else
      first_letter = user.email[0].upcase
      alt = options[:alt]
      style = ""

      content_tag(:div, first_letter, class: "flex items-center justify-center rounded-full #{css_class}", style: style, alt: alt)
    end
  end

  def avatar_src(user)
    return unless user

    if user.avatar?
      user_avatar_path(user)
    else
      user.oauth_avatar_url
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
    content_tag(:nav, class: 'flex space-x-1 md:space-x-3', aria: { label: 'Tabs' }) do
      safe_join(tabs.map do |tab|
        current_tab = selected == tab[:name]
        link_class = current_tab ? ui_active_tab : ui_tab
        link_options = current_tab ? { 'aria-current' => 'page' } : {}
        link_to tab[:name], tab[:path], class: link_class, **link_options
      end)
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

  def disable_email_login?
    Rails.application.config.app_settings[:disable_email_login]
  end

  def last_update_text(entity)
    "Last updated: #{l(entity.updated_at, format: :long)}"
  end

  def display_flash
    if alert
      content_tag(:p, alert, id: "notice", class: 'flash-alert p-3 text-sm mb-2')
    elsif notice
      content_tag(:p, notice, id: "alert", class: 'flash-notice p-3 text-sm mb-2')
    end
  end
end
