module UsersHelper
  def users_tabs(selected = nil)
    tabs = [
      { name: 'Account', path: edit_registration_path(current_user) },
      { name: 'Settings', path: users_settings_path }
    ]

    render_tabs(tabs, selected)
  end

  def oauth_provider_name(provider)
    provider == 'azure_activedirectory_v2' ? 'Microsoft' : 'Google'
  end
end
