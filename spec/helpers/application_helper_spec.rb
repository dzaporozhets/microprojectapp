require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
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

      expect(html).to have_css('a.btn-tab-active', text: 'Company')
    end

    it 'does not highlight non-selected tabs' do
      html = helper.render_tabs(tabs, 'Company')

      puts html
      expect(html).to have_css('a.btn-tab', text: 'My Account')
      expect(html).to have_css('a.btn-tab', text: 'Team Members')
    end

    it 'marks the selected tab with aria-current' do
      html = helper.render_tabs(tabs, 'Team Members')

      expect(html).to have_css('a[aria-current="page"]', text: 'Team Members')
    end
  end

  describe '#avatar_tag' do
    let(:user) { double('User', email: 'test@example.com', avatar_url: nil) }
    let(:default_options) { { size: 40, alt: 'Avatar' } }

    context 'when user has an avatar_url' do
      before do
        allow(user).to receive(:avatar_url).and_return('http://example.com/avatar.jpg')
      end

      it 'generates an image tag with the avatar_url' do
        result = helper.avatar_tag(user, 'css-class', default_options)

        expect(result).to include('img')
        expect(result).to include('http://example.com/avatar.jpg')
        expect(result).to include('class="rounded-full css-class"')
        expect(result).to include('alt="Avatar"')
      end
    end

    context 'when user does not have an avatar_url' do
      before do
        allow(user).to receive(:avatar_url).and_return(nil)
      end

      it 'generates a div with the correct initial' do
        result = helper.avatar_tag(user, 'css-class', default_options)

        expect(result).to include('T')
        expect(result).to include('alt="Avatar"')
        expect(result).to include('class="flex items-center justify-center rounded-full css-class"')
      end
    end
  end
end
