module AdminHelper
  def admin_tabs(selected = nil)
    tabs = [
      { name: 'Application', path: admin_path },
      { name: 'Users', path: admin_users_path }
    ]

    render_tabs(tabs, selected)
  end
end
