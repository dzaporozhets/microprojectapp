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

  def ui_toggle
    "tab-container"
  end

  def ui_toggle_tab
    "tab"
  end

  def ui_toggle_active_tab
    "tab-active #{theme_text}"
  end

  private

  def theme_bg
    case theme_name
    when 'violet' then 'bg-violet-200 dark:bg-violet-950'
    when 'pink' then 'bg-pink-200 dark:bg-pink-950'
    when 'orange' then 'bg-orange-200 dark:bg-orange-950'
    when 'indigo' then 'bg-indigo-200 dark:bg-indigo-950'
    when 'gray' then 'bg-gray-200 dark:bg-gray-950'
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
    when 'violet' then 'border-violet-300 dark:border-violet-800'
    when 'pink' then 'border-pink-300 dark:border-pink-800'
    when 'orange' then 'border-orange-300 dark:border-orange-800'
    when 'indigo' then 'border-indigo-300 dark:border-indigo-800'
    when 'gray' then 'border-gray-300 dark:border-gray-800'
    end
  end

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'violet'
  end
end
