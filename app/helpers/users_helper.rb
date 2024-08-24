module UsersHelper
  def users_tabs(selected = nil)
    tabs = [
      { name: 'Account', path: edit_registration_path(current_user) },
      { name: 'Settings', path: users_settings_path }
    ]

    render_tabs(tabs, selected)
  end
end
