module ThemeHelper
  def nav_color
    'bg-gray-200 dark:bg-gray-800 text-gray-900 dark:text-gray-400 border-b border-gray-300 dark:border-gray-700'.freeze
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

  def flash_css(type)
    case type.to_sym
    when :notice then 'bg-violet-50 border rounded border-violet-300 text-violet-900 dark:bg-violet-950 dark:border-violet-800 dark:text-violet-200'
    when :alert then 'bg-red-50 border rounded border-red-400 text-red-700 dark:bg-red-700 dark:text-white dark:border-red-800'
    else 'bg-gray-100 border rounded border-gray-500 text-gray-700 dark:bg-gray-700 dark:text-white dark:border-gray-600'
    end
  end
end
