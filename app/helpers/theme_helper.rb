module ThemeHelper
  def nav_color
    case theme_name
    when 'violet'
      "text-violet-900 dark:text-violet-300 bg-violet-100 dark:bg-violet-950 border-b border-violet-200 dark:border-violet-900"
    when 'lime'
      "text-lime-900 dark:text-lime-300 bg-lime-100 dark:bg-lime-950 border-b border-lime-200 dark:border-lime-900"
    when 'pink'
      "text-pink-900 dark:text-pink-300 bg-pink-100 dark:bg-pink-950 border-b border-pink-200 dark:border-pink-900"
    when 'sky'
      "text-sky-900 dark:text-sky-300 bg-sky-100 dark:bg-sky-950 border-b border-sky-200 dark:border-sky-900"
    else
      "text-gray-900 dark:text-gray-300 bg-gray-200 dark:bg-gray-800 border-b border-gray-300 dark:border-gray-700"
    end
  end

  def subnav_active_tab
    case theme_name
    when 'lime'
      'btn-tab btn-tab-active text-lime-900 dark:text-lime-100 bg-lime-100 dark:bg-lime-950 border-lime-300 dark:border-lime-900'
    when 'pink'
      'btn-tab btn-tab-active text-pink-900 dark:text-pink-100 bg-pink-100 dark:bg-pink-950 border-pink-300 dark:border-pink-900'
    when 'sky'
      'btn-tab btn-tab-active text-sky-900 dark:text-sky-100 bg-sky-100 dark:bg-sky-950 border-sky-300 dark:border-sky-900'
    else
      'btn-tab btn-tab-active text-violet-900 dark:text-violet-100 ' \
      'bg-violet-100 dark:bg-violet-950 border-violet-300 dark:border-violet-900'
    end
  end

  def subnav_css
    'py-3 border-b border-gray-200 dark:border-gray-800 text-gray-600 dark:text-gray-400'.freeze
  end

  def body_color
    'bg-gray-50 dark:bg-gray-900 text-gray-800 dark:text-gray-300'.freeze
  end

  def task_css(task)
    if task.done
      'px-4 py-1 rounded-md hover:bg-gray-50 dark:hover:bg-gray-800 ' \
        'text-sm text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-900 line-through ' \
        'dark:decoration-gray-500 decoration-gray-600'
    else
      'px-4 py-1 rounded-md hover:bg-gray-50 dark:hover:bg-gray-800 ' \
        'text-sm text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-800'
    end
  end

  def task_details_css(task)
    task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300' :
      'bg-gray-100 dark:bg-gray-800 text-black dark:text-gray-100'
  end

  def sub_subnav
    'inline-flex items-center gap-1 p-1 bg-gray-100 dark:bg-violet-950 rounded-full border border-violet-200 dark:border-violet-800'
  end

  def sub_subnav_tab
    'px-3 py-1 text-sm font-medium text-violet-900 rounded-full ' \
      'hover:bg-white hover:shadow-sm hover:ring-1 hover:ring-gray-300 ' \
      'focus:outline-none focus:ring-2 focus:ring-violet-500 ' \
      'dark:text-violet-200 dark:hover:bg-violet-300 dark:hover:text-violet-900'
  end

  def sub_subnav_active_tab
    'px-3 py-1 text-sm font-medium text-gray-800 bg-white rounded-full ' \
      'shadow-sm ring-1 ring-gray-300 focus:outline-none focus:ring-2 focus:ring-violet-500 ' \
      'dark:bg-violet-300'
  end

  private

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'gray'
  end
end
