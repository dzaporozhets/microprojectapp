module ApplicationHelper
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
    elsif user.oauth_avatar_url.present?
      user.oauth_avatar_url
    elsif user.use_gravatar?
      gravatar_url(user.email)
    end
  end

  def gravatar_url(email, size: 80)
    hash = Digest::SHA256.hexdigest(email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=404"
  end

  def time_ago_short(time)
    return unless time

    time_ago_in_words(time).gsub('less than a minute', 'now')
      .gsub('about ', '')
  end

  def render_tabs(tabs, selected = nil)
    content_tag(:nav, class: 'flex nav-tabs tab-container', aria: { label: 'Tabs' }) do
      safe_join(tabs.map do |tab|
        current_tab = selected == tab[:name]
        link_class = current_tab ? 'tab-active theme-text' : 'tab'
        link_options = current_tab ? { 'aria-current' => 'page' } : {}
        link_to tab[:name], tab[:path], class: link_class, **link_options
      end)
    end
  end

  def html_class
    return unless current_user

    classes = []

    case current_user.dark_mode
    when 'on'
      classes << 'light'
    when 'off'
      classes << 'dark'
    end

    classes << 'compact' if current_user.compact_mode?

    classes.join(' ')
  end

  def body_class
    theme = current_user&.theme_css_name || 'violet'
    "body-color theme-#{theme}"
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
