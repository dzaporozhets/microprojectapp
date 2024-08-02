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
end
