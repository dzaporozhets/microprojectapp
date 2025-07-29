module CssHelper
  def body_color
    'bg-neutral-100 dark:bg-gray-950 text-gray-800 dark:text-gray-300'
  end

  def nav_color
    "#{theme_text} #{theme_bg} border-b #{theme_border}"
  end

  def subnav_active_tab
    "btn-tab btn-tab-active #{theme_text} #{theme_bg} #{theme_border_accent}"
  end

  def subnav_css
    'py-3 border-b border-gray-200 dark:border-gray-800 text-gray-600 dark:text-gray-400'
  end

  def task_css(task)
    if task.done
      "px-3 py-1 text-sm text-gray-700 dark:text-gray-400" \
      " line-through dark:decoration-gray-400 decoration-gray-600" \
      "  hover:bg-neutral-50 dark:hover:bg-gray-800"
    else
      "px-3 py-1 text-sm text-black dark:text-gray-100" \
        " hover:bg-neutral-50 dark:hover:bg-gray-800"
    end
  end

  def task_details_css(task)
    task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300' :
      'bg-gray-100 dark:bg-gray-800 text-black dark:text-gray-100'
  end

  def sub_subnav
    "inline-flex items-center gap-1 p-1 #{theme_bg_subtle} rounded-full border #{theme_border}"
  end

  def sub_subnav_tab
    "px-3 py-1 text-sm border border-transparent font-medium rounded-full #{theme_hover} #{theme_focus_ring} " \
      'hover:bg-white hover:shadow-sm focus:outline-none focus:ring-2 '
  end

  def sub_subnav_active_tab
    "px-3 py-1 text-sm border #{theme_border} #{theme_bg} #{theme_text} #{theme_focus_ring} font-medium rounded-full " \
      "shadow-sm focus:outline-none focus:ring-2 "
  end

  # Button styles
  def theme_button_primary
    "btn border #{theme_bg} #{theme_text} #{theme_border} #{theme_hover}"
  end

  def theme_link_primary
    "#{theme_text} hover:#{theme_text_subtle}"
  end

  # Checkbox round style
  def theme_checkbox_round
    "#{theme_focus_ring_visible} #{theme_text_subtle} bg-gray-100" \
      " border-gray-300 dark:border-gray-600 rounded-xl focus-visible:ring-2 dark:bg-gray-700"
  end
end
