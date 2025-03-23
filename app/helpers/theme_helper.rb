module ThemeHelper
  def nav_color
    theme_name = current_user ? current_user.theme_css_name : 'gray'

    case theme_name
    when 'blue'
      "text-blue-900 dark:text-blue-200 bg-blue-100 dark:bg-blue-900 border-b border-blue-200 dark:border-blue-700"
    when 'green'
      "text-green-900 dark:text-green-200 bg-green-100 dark:bg-green-900 border-b border-green-200 dark:border-green-700"
    when 'red'
      "text-red-900 dark:text-red-200 bg-red-100 dark:bg-red-900 border-b border-red-200 dark:border-red-700"
    when 'yellow'
      "text-yellow-900 dark:text-yellow-200 bg-yellow-100 dark:bg-yellow-900 border-b border-yellow-200 dark:border-yellow-700"
    when 'violet'
      "text-violet-900 dark:text-violet-200 bg-violet-100 dark:bg-violet-900 border-b border-violet-200 dark:border-violet-700"
    when 'black'
      "text-gray-200 dark:text-gray-400 bg-black border-b border-black"
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
