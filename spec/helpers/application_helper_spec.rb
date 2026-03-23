require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { build_stubbed(:user) }

  before do
    allow(helper).to receive(:current_user).and_return(user)
  end


  describe '#time_ago_short' do
    it 'returns "now" for times less than a minute ago' do
      expect(helper.time_ago_short(Time.current)).to eq('now')
    end

    it 'returns 3 hours without about' do
      time = 3.hours.ago
      expect(helper.time_ago_short(time)).to eq('3 hours')
    end

    it 'returns 1 hour without about' do
      time = 45.minutes.ago
      expect(helper.time_ago_short(time)).to eq('1 hour')
    end

    it 'returns nil if time is nil' do
      expect(helper.time_ago_short(nil)).to be_nil
    end
  end

  describe '#render_tabs' do
    let(:tabs) do
      [
        { name: 'My Account', path: '/account' },
        { name: 'Company', path: '/company' },
        { name: 'Team Members', path: '/team' }
      ]
    end

    it 'renders all tabs' do
      html = helper.render_tabs(tabs)

      expect(html).to have_link('My Account', href: '/account')
      expect(html).to have_link('Company', href: '/company')
      expect(html).to have_link('Team Members', href: '/team')
    end

    it 'highlights the selected tab' do
      html = helper.render_tabs(tabs, 'Company')

      expect(html).to have_css('a.tab-active', text: 'Company')
    end

    it 'does not highlight non-selected tabs' do
      html = helper.render_tabs(tabs, 'Company')

      puts html
      expect(html).to have_css('a.tab', text: 'My Account')
      expect(html).to have_css('a.tab', text: 'Team Members')
    end

    it 'marks the selected tab with aria-current' do
      html = helper.render_tabs(tabs, 'Team Members')

      expect(html).to have_css('a[aria-current="page"]', text: 'Team Members')
    end
  end

  describe '#avatar_src' do
    let(:user) { double('User', id: 1, email: 'test@example.com') }

    context 'when user has an uploaded avatar' do
      before do
        allow(user).to receive(:avatar?).and_return(true)
        allow(helper).to receive(:user_avatar_path).with(user).and_return('/users/1/avatar')
      end

      it 'returns the uploaded avatar path' do
        expect(helper.avatar_src(user)).to eq('/users/1/avatar')
      end
    end

    context 'when user has an oauth avatar' do
      before do
        allow(user).to receive(:avatar?).and_return(false)
        allow(user).to receive(:oauth_avatar_url).and_return('https://oauth.example.com/photo.jpg')
        allow(user).to receive(:use_gravatar?).and_return(true)
      end

      it 'returns oauth_avatar_url over gravatar' do
        expect(helper.avatar_src(user)).to eq('https://oauth.example.com/photo.jpg')
      end
    end

    context 'when user has gravatar enabled' do
      before do
        allow(user).to receive(:avatar?).and_return(false)
        allow(user).to receive(:oauth_avatar_url).and_return(nil)
        allow(user).to receive(:use_gravatar?).and_return(true)
      end

      it 'returns gravatar URL' do
        result = helper.avatar_src(user)
        expect(result).to start_with('https://www.gravatar.com/avatar/')
      end
    end

    context 'when user has no avatar at all' do
      before do
        allow(user).to receive(:avatar?).and_return(false)
        allow(user).to receive(:oauth_avatar_url).and_return(nil)
        allow(user).to receive(:use_gravatar?).and_return(false)
      end

      it 'returns nil' do
        expect(helper.avatar_src(user)).to be_nil
      end
    end

    it 'returns nil when user is nil' do
      expect(helper.avatar_src(nil)).to be_nil
    end
  end

  describe '#gravatar_url' do
    it 'returns a gravatar URL with SHA256 hash' do
      result = helper.gravatar_url('test@example.com')
      hash = Digest::SHA256.hexdigest('test@example.com')
      expect(result).to eq("https://www.gravatar.com/avatar/#{hash}?s=80&d=404")
    end

    it 'normalizes email case and whitespace' do
      result = helper.gravatar_url(' Test@Example.com ')
      hash = Digest::SHA256.hexdigest('test@example.com')
      expect(result).to include(hash)
    end
  end

  describe '#avatar_tag' do
    let(:user) { double('User', id: 1, email: 'test@example.com') }
    let(:default_options) { { size: 40, alt: 'Avatar' } }

    context 'when user has an uploaded avatar' do
      before do
        allow(user).to receive(:avatar?).and_return(true)
        allow(helper).to receive(:user_avatar_path).with(user).and_return('/users/1/avatar')
      end

      it 'generates an image tag with the avatar path' do
        result = helper.avatar_tag(user, 'css-class', default_options)

        expect(result).to include('img')
        expect(result).to include('/users/1/avatar')
        expect(result).to include('class="rounded-full css-class"')
        expect(result).to include('alt="Avatar"')
      end
    end

    context 'when user does not have an avatar' do
      before do
        allow(user).to receive(:avatar?).and_return(false)
        allow(user).to receive(:oauth_avatar_url).and_return(nil)
        allow(user).to receive(:use_gravatar?).and_return(false)
      end

      it 'generates a div with the correct initial' do
        result = helper.avatar_tag(user, 'css-class', default_options)

        expect(result).to include('T')
        expect(result).to include('alt="Avatar"')
        expect(result).to include('class="flex items-center justify-center rounded-full css-class"')
      end
    end
  end

  describe '#home_tabs' do
    before do
      allow(helper).to receive(:projects_path).and_return("/projects")
      allow(helper).to receive(:schedule_path).and_return("/schedule")
    end

    it 'constructs the correct tabs array' do
      expected_tabs = [
        { name: 'Projects', path: "/projects" },
        { name: 'Tasks', path: "/tasks" },
        { name: 'Notes', path: "/notes" }
      ]

      expect(helper).to receive(:render_tabs).with(expected_tabs, nil)

      helper.home_tabs
    end

    it 'passes the selected tab to render_tabs' do
      selected_tab = 'Projects'

      expected_tabs = [
        { name: 'Projects', path: "/projects" },
        { name: 'Tasks', path: "/tasks" },
        { name: 'Notes', path: "/notes" }
      ]

      expect(helper).to receive(:render_tabs).with(expected_tabs, selected_tab)

      helper.home_tabs(selected_tab)
    end
  end
end
