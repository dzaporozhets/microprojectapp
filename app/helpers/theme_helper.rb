module ThemeHelper
  def theme_bg_neutral
    'bg-gray-200 dark:bg-gray-800'
  end

  def theme_bg
    case theme_name
    when 'violet' then 'bg-violet-200 dark:bg-violet-900'
    when 'lime' then 'bg-lime-200 dark:bg-lime-900'
    when 'pink' then 'bg-pink-200 dark:bg-pink-900'
    when 'sky' then 'bg-sky-200 dark:bg-sky-900'
    when 'gray' then 'bg-gray-200 dark:bg-gray-900'
    end
  end

  def theme_bg_subtle
    case theme_name
    when 'violet' then 'bg-violet-50 dark:bg-violet-950'
    when 'lime' then 'bg-lime-50 dark:bg-lime-950'
    when 'pink' then 'bg-pink-50 dark:bg-pink-950'
    when 'sky' then 'bg-sky-50 dark:bg-sky-950'
    when 'gray' then 'bg-gray-50 dark:bg-gray-950'
    end
  end

  # Text colors
  def theme_text
    case theme_name
    when 'violet' then 'text-violet-900 dark:text-violet-100'
    when 'lime' then 'text-lime-900 dark:text-lime-100'
    when 'pink' then 'text-pink-900 dark:text-pink-100'
    when 'sky' then 'text-sky-900 dark:text-sky-100'
    when 'gray' then 'text-gray-900 dark:text-gray-100'
    end
  end

  def theme_text_subtle
    case theme_name
    when 'violet' then 'text-violet-700 dark:text-violet-300'
    when 'lime' then 'text-lime-700 dark:text-lime-300'
    when 'pink' then 'text-pink-700 dark:text-pink-300'
    when 'sky' then 'text-sky-700 dark:text-sky-300'
    when 'gray' then 'text-gray-700 dark:text-gray-300'
    end
  end

  # Border colors
  def theme_border
    case theme_name
    when 'violet' then 'border-violet-300 dark:border-violet-800'
    when 'lime' then 'border-lime-300 dark:border-lime-800'
    when 'pink' then 'border-pink-300 dark:border-pink-800'
    when 'sky' then 'border-sky-300 dark:border-sky-800'
    when 'gray' then 'border-gray-300 dark:border-gray-800'
    end
  end

  def theme_border_accent
    case theme_name
    when 'violet' then 'border-violet-400 dark:border-violet-700'
    when 'lime' then 'border-lime-400 dark:border-lime-700'
    when 'pink' then 'border-pink-400 dark:border-pink-700'
    when 'sky' then 'border-sky-400 dark:border-sky-700'
    when 'gray' then 'border-gray-400 dark:border-gray-700'
    end
  end

  def theme_hover
    case theme_name
    when 'violet' then 'hover:bg-violet-50 hover:dark:bg-violet-800 hover:border-violet-100 hover:dark:border-violet-700'
    when 'lime' then 'hover:bg-lime-50 hover:dark:bg-lime-800 hover:border-lime-100 hover:dark:border-lime-700'
    when 'pink' then 'hover:bg-pink-50 hover:dark:bg-pink-800 hover:border-pink-100 hover:dark:border-pink-700'
    when 'sky' then 'hover:bg-sky-50 hover:dark:bg-sky-800 hover:border-sky-100 hover:dark:border-sky-700'
    when 'gray' then 'hover:bg-gray-50 hover:dark:bg-gray-800 hover:border-gray-100 hover:dark:border-gray-700'
    end
  end

  def theme_focus_ring
    case theme_name
    when 'violet' then 'focus:ring-violet-500'
    when 'lime' then 'focus:ring-lime-500'
    when 'pink' then 'focus:ring-pink-500'
    when 'sky' then 'focus:ring-sky-500'
    when 'gray' then 'focus:ring-gray-500'
    end
  end

  def theme_focus_ring_visible
    case theme_name
    when 'violet' then 'focus-visible:ring-violet-500'
    when 'lime' then 'focus-visible:ring-lime-500'
    when 'pink' then 'focus-visible:ring-pink-500'
    when 'sky' then 'focus-visible:ring-sky-500'
    when 'gray' then 'focus-visible:ring-gray-500'
    end
  end

  private

  def theme_name
    @theme_name ||= current_user ? current_user.theme_css_name : 'gray'
  end
end
