module ThemeHelper
  def nav_color
    'bg-zinc-200 dark:bg-gray-900 text-gray-900 dark:text-gray-400 border-b border-zinc-300 dark:border-gray-800'.freeze
  end

  def subnav_color
    'border-b border-neutral-200 dark:border-gray-800'.freeze
  end

  def body_color
    'bg-neutral-50 dark:bg-gray-950 text-gray-800 dark:text-gray-300'.freeze
  end

  def task_css(task)
    base_css = 'border rounded-md px-3 py-1 shadow-sm '.freeze
    task_done_css = 'bg-neutral-100 dark:bg-gray-950 border-neutral-100 dark:border-gray-800 line-through dark:decoration-gray-400 decoration-black text-neutral-600 dark:text-gray-400'.freeze
    task_todo_css = 'bg-white dark:bg-gray-900 border-neutral-100 dark:border-gray-800 text-black dark:text-neutral-200'.freeze

    base_css + (task.done ? task_done_css : task_todo_css)
  end

  def task_details_css(task)
    @task.done ?
      'bg-gray-300 dark:bg-gray-700 text-gray-700 dark:text-gray-300 border-b-gray-200 dark:border-b-gray-600 ' :
      'bg-zinc-100 dark:bg-slate-800 text-black dark:text-gray-100 border-b-zinc-200 dark:border-b-gray-700 '
  end

  def flash_css(type)
    case type.to_sym
    when :notice then 'bg-violet-50 border rounded border-violet-300 text-violet-900 dark:bg-violet-950 dark:border-violet-800 dark:text-violet-200'
    when :alert then 'bg-red-50 border rounded border-red-400 text-red-700 dark:bg-red-700 dark:text-white dark:border-red-800'
    else 'bg-gray-100 border rounded border-gray-500 text-gray-700 dark:bg-gray-700 dark:text-white dark:border-gray-600'
    end
  end
end
