module UsersHelper
  def users_tabs(selected = nil)
    tabs = [
      { name: 'Settings', path: users_settings_path },
      { name: 'Account', path: users_account_path }
    ]

    tabs << { name: 'Password', path: edit_registration_path(current_user) } unless DISABLE_EMAIL_LOGIN || current_user.oauth_user?

    render_tabs(tabs, selected)
  end

  def oauth_provider_name(provider)
    provider == 'google_oauth2' ? 'Google' : 'Microsoft'
  end
end
