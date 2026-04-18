module CssHelper
  def nav_color
    "#{theme_text} #{theme_bg} border-b #{theme_border}"
  end

  def ui_tabs
    "tab-container"
  end

  def ui_tab
    "tab"
  end

  def ui_active_tab
    "tab-active #{theme_text}"
  end

  def theme_bg
    case theme_name
    when 'violet' then 'bg-violet-200 dark:bg-violet-950'
    when 'pink' then 'bg-pink-200 dark:bg-pink-950'
    when 'orange' then 'bg-orange-200 dark:bg-orange-950'
    when 'indigo' then 'bg-indigo-200 dark:bg-indigo-950'
    when 'gray' then 'bg-gray-200 dark:bg-gray-950'
    end
  end

  def sidebar_link(path = nil)
    classes = [
      'flex items-center gap-x-2 rounded-md p-2 text-sm font-medium transition-colors',
      sidebar_link_hover_background,
      theme_text
    ]

    classes << sidebar_link_active_background if path && current_page?(path)
    classes.join(' ')
  end

  private

  def sidebar_link_hover_background
    case theme_name
    when 'violet' then 'hover:bg-violet-950/5 dark:hover:bg-violet-100/5'
    when 'pink' then 'hover:bg-pink-950/5 dark:hover:bg-pink-100/5'
    when 'orange' then 'hover:bg-orange-950/5 dark:hover:bg-orange-100/5'
    when 'indigo' then 'hover:bg-indigo-950/5 dark:hover:bg-indigo-100/5'
    when 'gray' then 'hover:bg-gray-950/5 dark:hover:bg-gray-100/5'
    end
  end

  def sidebar_link_active_background
    case theme_name
    when 'violet' then 'bg-violet-950/5 dark:bg-violet-100/5'
    when 'pink' then 'bg-pink-950/5 dark:bg-pink-100/5'
    when 'orange' then 'bg-orange-950/5 dark:bg-orange-100/5'
    when 'indigo' then 'bg-indigo-950/5 dark:bg-indigo-100/5'
    when 'gray' then 'bg-gray-950/5 dark:bg-gray-100/5'
    end
  end

  def theme_text
    case theme_name
    when 'violet' then 'text-violet-900 dark:text-violet-100'
    when 'pink' then 'text-pink-900 dark:text-pink-100'
    when 'orange' then 'text-orange-900 dark:text-orange-100'
    when 'indigo' then 'text-indigo-900 dark:text-indigo-100'
    when 'gray' then 'text-gray-900 dark:text-gray-100'
    end
  end

  def theme_border
    case theme_name
    when 'violet' then 'border-violet-300 dark:border-violet-800/50'
    when 'pink' then 'border-pink-300 dark:border-pink-800/50'
    when 'orange' then 'border-orange-300 dark:border-orange-800/50'
    when 'indigo' then 'border-indigo-300 dark:border-indigo-800/50'
    when 'gray' then 'border-gray-300 dark:border-gray-800/50'
    end
  end

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'violet'
  end
end
