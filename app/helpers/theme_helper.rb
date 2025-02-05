module ThemeHelper
  def nav_color
    'bg-gray-200 dark:bg-gray-900 text-gray-900 dark:text-gray-400 border-b border-gray-300 dark:border-gray-800'.freeze
  end

  def body_color
    'bg-white dark:bg-gray-950 text-gray-800 dark:text-gray-300'.freeze
  end

  def task_css(task)
    base_css = 'border shadow-sm dark:shadow-gray-800 rounded-md px-3 py-1.5 '.freeze
    task_done_css = 'bg-gray-200 dark:bg-gray-950 border-gray-200 dark:border-gray-800 line-through dark:decoration-gray-100'.freeze
    task_todo_css = 'bg-gray-100 dark:bg-gray-900 border-gray-100 dark:border-gray-800'.freeze

    base_css + (task.done ? task_done_css : task_todo_css)
  end
end
