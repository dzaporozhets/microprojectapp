module ThemeHelper
  # Theme CSS classes

  # Background colors
  def theme_bg_neutral
    'bg-gray-200 dark:bg-gray-800'
  end

  def theme_bg
    case theme_name
    when 'violet' then 'bg-violet-100 dark:bg-violet-950'
    when 'lime' then 'bg-lime-100 dark:bg-lime-950'
    when 'pink' then 'bg-pink-100 dark:bg-pink-950'
    when 'sky' then 'bg-sky-100 dark:bg-sky-950'
    else 'bg-gray-200 dark:bg-gray-800'
    end
  end

  def theme_bg_subtle
    case theme_name
    when 'violet' then 'bg-violet-50 dark:bg-violet-900'
    when 'lime' then 'bg-lime-50 dark:bg-lime-900'
    when 'pink' then 'bg-pink-50 dark:bg-pink-900'
    when 'sky' then 'bg-sky-50 dark:bg-sky-900'
    else 'bg-gray-50 dark:bg-gray-700'
    end
  end

  # Text colors
  def theme_text
    case theme_name
    when 'violet' then 'text-violet-900 dark:text-violet-300'
    when 'lime' then 'text-lime-900 dark:text-lime-300'
    when 'pink' then 'text-pink-900 dark:text-pink-300'
    when 'sky' then 'text-sky-900 dark:text-sky-300'
    else 'text-gray-900 dark:text-gray-300'
    end
  end

  def theme_text_subtle
    case theme_name
    when 'violet' then 'text-violet-700 dark:text-violet-400'
    when 'lime' then 'text-lime-700 dark:text-lime-400'
    when 'pink' then 'text-pink-700 dark:text-pink-400'
    when 'sky' then 'text-sky-700 dark:text-sky-400'
    else 'text-gray-700 dark:text-gray-400'
    end
  end

  # Border colors
  def theme_border
    case theme_name
    when 'violet' then 'border-violet-200 dark:border-violet-900'
    when 'lime' then 'border-lime-200 dark:border-lime-900'
    when 'pink' then 'border-pink-200 dark:border-pink-900'
    when 'sky' then 'border-sky-200 dark:border-sky-900'
    else 'border-gray-300 dark:border-gray-700'
    end
  end

  def theme_border_accent
    case theme_name
    when 'violet' then 'border-violet-300 dark:border-violet-800'
    when 'lime' then 'border-lime-300 dark:border-lime-800'
    when 'pink' then 'border-pink-300 dark:border-pink-800'
    when 'sky' then 'border-sky-300 dark:border-sky-800'
    else 'border-gray-400 dark:border-gray-600'
    end
  end

  # Hover states
  def theme_hover
    case theme_name
    when 'violet' then 'hover:bg-violet-50 hover:dark:bg-violet-800 hover:border-violet-100 hover:dark:border-violet-700'
    when 'lime' then 'hover:bg-lime-50 hover:dark:bg-lime-800 hover:border-lime-100 hover:dark:border-lime-700'
    when 'pink' then 'hover:bg-pink-50 hover:dark:bg-pink-800 hover:border-pink-100 hover:dark:border-pink-700'
    when 'sky' then 'hover:bg-sky-50 hover:dark:bg-sky-800 hover:border-sky-100 hover:dark:border-sky-700'
    else 'hover:bg-gray-50 hover:dark:bg-gray-700 hover:border-gray-100 hover:dark:border-gray-600'
    end
  end

  # Active state
  def theme_active_bg
    case theme_name
    when 'violet' then 'dark:bg-violet-300'
    when 'lime' then 'dark:bg-lime-300'
    when 'pink' then 'dark:bg-pink-300'
    when 'sky' then 'dark:bg-sky-300'
    else 'dark:bg-gray-300'
    end
  end

  # Maintain backward compatibility with existing methods
  def nav_color
    "#{theme_text} #{theme_bg} border-b #{theme_border}"
  end

  def subnav_active_tab
    "btn-tab btn-tab-active #{theme_text} #{theme_bg} #{theme_border_accent}"
  end

  def subnav_css
    'py-3 border-b border-gray-200 dark:border-gray-800 text-gray-600 dark:text-gray-400'
  end

  def body_color
    'bg-neutral-100 dark:bg-gray-900 text-gray-800 dark:text-gray-300'
  end

  def base_task_css
    'px-3 py-1 rounded-lg text-sm border'
  end

  def task_css(task)
    if task.done
      "#{base_task_css} text-gray-600 dark:text-gray-400 bg-gray-100 dark:bg-gray-900" \
      " line-through dark:decoration-gray-400 decoration-gray-600" \
      " border-gray-200 dark:border-gray-900 #{theme_hover}"
    else
      "#{base_task_css} text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-800" \
      " border-gray-200 dark:border-gray-700 #{theme_hover}"
    end
  end

  def task_details_css(task)
    task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300' :
      'bg-gray-100 dark:bg-gray-800 text-black dark:text-gray-100'
  end

  def sub_subnav
    "inline-flex items-center gap-1 p-1 #{theme_bg_neutral} rounded-full border #{theme_border}"
  end

  def sub_subnav_tab
    "px-3 py-1 text-sm font-medium #{theme_text} rounded-full " \
      'hover:bg-white hover:shadow-sm hover:ring-1 hover:ring-gray-300 ' \
      'focus:outline-none focus:ring-2 focus:ring-violet-500 ' \
      'dark:hover:bg-violet-300 dark:hover:text-violet-900'
  end

  def sub_subnav_active_tab
    "px-3 py-1 text-sm font-medium text-gray-800 bg-white rounded-full " \
      "shadow-sm ring-1 ring-gray-300 focus:outline-none focus:ring-2 focus:ring-violet-500 " \
      "#{theme_active_bg}"
  end

  # Button styles
  def theme_button_primary
    "btn border #{theme_bg} #{theme_text} #{theme_border} #{theme_hover}"
  end

  # Checkbox round style
  def theme_checkbox_round
    checkbox_color = case theme_name
                     when 'violet' then 'focus-visible:ring-violet-500'
                     when 'lime' then 'focus-visible:ring-lime-500'
                     when 'pink' then 'focus-visible:ring-pink-500'
                     when 'sky' then 'focus-visible:ring-sky-500'
                     else 'focus-visible:ring-gray-500'
                     end

    "#{checkbox_color} #{theme_text_subtle} bg-gray-100" \
      " border-gray-300 dark:border-gray-600 rounded-xl focus-visible:ring-2 dark:bg-gray-700"
  end

  private

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'gray'
  end
end
