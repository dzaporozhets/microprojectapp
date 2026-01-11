module CssHelper
  def nav_color
    "#{theme_text} #{theme_bg} border-b #{theme_border}"
  end

  def ui_tabs
    ""
  end

  def ui_tab
    "btn-tab #{theme_text_subtle}"
  end

  def ui_active_tab
    "btn-tab btn-tab-active #{theme_text} #{theme_bg} #{theme_border_accent}"
  end

  def ui_toggle
    "inline-flex items-center gap-1 p-1 #{theme_bg_subtle} rounded-full border #{theme_border}"
  end

  def ui_toggle_tab
    "px-3 py-0.5 text-sm border border-transparent font-medium rounded-full #{theme_hover} #{theme_text} #{theme_focus_ring} " \
      'hover:bg-white hover:shadow-sm focus:outline-none focus:ring-2 '
  end

  def ui_toggle_active_tab
    "px-3 py-0.5 text-sm border #{theme_border} #{theme_bg} #{theme_text} #{theme_focus_ring} font-medium rounded-full " \
      "shadow-sm focus:outline-none focus:ring-2 "
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

  def theme_bg_subtle
    case theme_name
    when 'violet' then 'bg-violet-50 dark:bg-violet-900'
    when 'pink' then 'bg-pink-50 dark:bg-pink-900'
    when 'orange' then 'bg-orange-50 dark:bg-orange-900'
    when 'indigo' then 'bg-indigo-50 dark:bg-indigo-900'
    when 'gray' then 'bg-gray-50 dark:bg-gray-900'
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

  def theme_text_subtle
    case theme_name
    when 'violet' then 'text-violet-800 dark:text-violet-200'
    when 'pink' then 'text-pink-800 dark:text-pink-200'
    when 'orange' then 'text-orange-800 dark:text-orange-200'
    when 'indigo' then 'text-indigo-800 dark:text-indigo-200'
    when 'gray' then 'text-base'
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

  def theme_border_accent
    case theme_name
    when 'violet' then 'border-violet-400 dark:border-violet-700'
    when 'pink' then 'border-pink-400 dark:border-pink-700'
    when 'orange' then 'border-orange-400 dark:border-orange-700'
    when 'indigo' then 'border-indigo-400 dark:border-indigo-700'
    when 'gray' then 'border-gray-400 dark:border-gray-700'
    end
  end

  def theme_hover
    case theme_name
    when 'violet' then 'hover:bg-violet-50 hover:dark:bg-violet-950 hover:border-violet-100 hover:dark:border-violet-700'
    when 'pink' then 'hover:bg-pink-50 hover:dark:bg-pink-950 hover:border-pink-100 hover:dark:border-pink-700'
    when 'orange' then 'hover:bg-orange-50 hover:dark:bg-orange-950 hover:border-orange-100 hover:dark:border-orange-700'
    when 'indigo' then 'hover:bg-indigo-50 hover:dark:bg-indigo-950 hover:border-indigo-100 hover:dark:border-indigo-700'
    when 'gray' then 'hover:bg-gray-50 hover:dark:bg-gray-950 hover:border-gray-100 hover:dark:border-gray-700'
    end
  end

  def theme_focus_ring
    case theme_name
    when 'violet' then 'focus:ring-violet-500'
    when 'pink' then 'focus:ring-pink-500'
    when 'orange' then 'focus:ring-orange-500'
    when 'indigo' then 'focus:ring-indigo-500'
    when 'gray' then 'focus:ring-gray-500'
    end
  end

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'violet'
  end
end
