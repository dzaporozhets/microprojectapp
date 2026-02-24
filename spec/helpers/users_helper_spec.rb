# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#oauth_provider_name' do
    it 'returns "Google" for google_oauth2' do
      expect(helper.oauth_provider_name('google_oauth2')).to eq('Google')
    end

    it 'returns "Microsoft" for any other provider' do
      expect(helper.oauth_provider_name('microsoft')).to eq('Microsoft')
    end
  end

  describe '#users_tabs' do
    let(:user) { double('User', oauth_user?: false) }

    before do
      allow(helper).to receive(:current_user).and_return(user)
      allow(helper).to receive(:disable_email_login?).and_return(false)
      allow(helper).to receive(:users_settings_path).and_return('/users/settings')
      allow(helper).to receive(:users_account_path).and_return('/users/account')
      allow(helper).to receive(:edit_registration_path).and_return('/users/password/edit')
      allow(helper).to receive(:render_tabs) { |tabs, _| tabs }
    end

    context 'when email login is enabled and user is not an oauth user' do
      it 'includes the Password tab' do
        tabs = helper.users_tabs
        expect(tabs.map { |t| t[:name] }).to include('Password')
      end
    end

    context 'when disable_email_login? is true' do
      before { allow(helper).to receive(:disable_email_login?).and_return(true) }

      it 'excludes the Password tab' do
        tabs = helper.users_tabs
        expect(tabs.map { |t| t[:name] }).not_to include('Password')
      end
    end

    context 'when current_user is an oauth user' do
      before { allow(user).to receive(:oauth_user?).and_return(true) }

      it 'excludes the Password tab' do
        tabs = helper.users_tabs
        expect(tabs.map { |t| t[:name] }).not_to include('Password')
      end
    end
  end
end
