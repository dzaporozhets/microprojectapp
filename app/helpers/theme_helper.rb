module ThemeHelper
  def nav_color
    theme_name = current_user ? current_user.theme_css_name : 'gray'

    case theme_name
    when 'violet'
      "text-violet-900 dark:text-violet-200 bg-violet-100 dark:bg-violet-900 border-b border-violet-200 dark:border-violet-700"
    when 'lime'
      "text-lime-900 dark:text-lime-200 bg-lime-100 dark:bg-lime-900 border-b border-lime-200 dark:border-lime-700"
    when 'pink'
      "text-pink-900 dark:text-pink-200 bg-pink-100 dark:bg-pink-900 border-b border-pink-200 dark:border-pink-700"
    when 'black'
      "text-gray-300 dark:text-gray-400 bg-black border-b border-black"
    else
      "text-gray-900 dark:text-gray-400 bg-gray-200 dark:bg-gray-800 border-b border-gray-300 dark:border-gray-700"
    end
  end

  def subnav_color
    'border-b border-gray-200 dark:border-gray-800 text-gray-600 dark:text-gray-400'.freeze
  end

  def body_color
    'bg-gray-50 dark:bg-gray-900 text-gray-800 dark:text-gray-300'.freeze
  end

  def task_css(task)
    task.done ? 'task-item-done' : 'task-item-todo'
  end

  def task_details_css(task)
    @task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300' :
      'bg-gray-100 dark:bg-gray-800 text-black dark:text-gray-100'
  end
end
