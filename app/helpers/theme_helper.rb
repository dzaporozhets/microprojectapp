module ThemeHelper
  def nav_color
    case theme_name
    when 'violet'
      "text-violet-900 dark:text-violet-200 bg-violet-100 dark:bg-violet-900 border-b border-violet-200 dark:border-violet-700"
    when 'lime'
      "text-lime-900 dark:text-lime-200 bg-lime-100 dark:bg-lime-900 border-b border-lime-200 dark:border-lime-700"
    when 'pink'
      "text-pink-900 dark:text-pink-200 bg-pink-100 dark:bg-pink-900 border-b border-pink-200 dark:border-pink-700"
    else
      "text-gray-900 dark:text-gray-400 bg-gray-200 dark:bg-gray-800 border-b border-gray-300 dark:border-gray-700"
    end
  end

  def subnav_active_tab
    case theme_name
    when 'lime'
      'btn-tab btn-tab-active text-lime-900 dark:text-lime-100 bg-lime-100 dark:bg-lime-950 border-lime-300 dark:border-lime-800'
    when 'pink'
      'btn-tab btn-tab-active text-pink-900 dark:text-pink-100 bg-pink-100 dark:bg-pink-950 border-pink-300 dark:border-pink-800'
    else
      'btn-tab btn-tab-active text-violet-900 dark:text-violet-100 bg-violet-100 dark:bg-violet-950 border-violet-300 dark:border-violet-800'
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
      'px-3 py-1 border-l-4 border-transparent hover:border-gray-400 transition' +
        'text-sm text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-900 line-through' +
        'dark:decoration-gray-500 decoration-gray-600'
    else
      'px-3 py-1 border-l-4 border-transparent hover:border-violet-400 transition' +
        'text-sm text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-800'
    end
  end

  def task_details_css(task)
    @task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300' :
      'bg-gray-100 dark:bg-gray-800 text-black dark:text-gray-100'
  end

  private

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'gray'
  end
end
