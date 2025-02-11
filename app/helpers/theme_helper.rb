module ThemeHelper
  def nav_color
    'bg-gray-200 dark:bg-gray-900 text-gray-900 dark:text-gray-400 border-b border-gray-300 dark:border-gray-800'.freeze
  end

  def subnav_color
    'border-b border-gray-200 dark:border-gray-800'.freeze
  end

  def body_color
    'bg-neutral-50 dark:bg-gray-950 text-gray-800 dark:text-gray-300'.freeze
  end

  def task_css(task)
    base_css = 'border rounded-md px-3 py-1 shadow-xs '.freeze
    task_done_css = 'bg-neutral-100 dark:bg-gray-950 border-neutral-100 dark:border-gray-800 line-through dark:decoration-gray-400 decoration-black text-neutral-600 dark:text-gray-400'.freeze
    task_todo_css = 'bg-white dark:bg-gray-900 border-neutral-200 dark:border-gray-800 text-black dark:text-neutral-200'.freeze

    base_css + (task.done ? task_done_css : task_todo_css)
  end

  def task_details_css(task)
    @task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300 border-b-gray-200 dark:border-b-gray-600 ' :
      'bg-slate-200 dark:bg-slate-800 text-slate-900 dark:text-slate-100 border-b-slate-300 dark:border-b-slate-700 '
  end
end
