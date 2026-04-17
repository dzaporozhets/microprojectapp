require 'rails_helper'

RSpec.describe CssHelper, type: :helper do
  let(:user) { create(:user, theme: 5) }

  before do
    allow(helper).to receive(:current_user).and_return(user)
  end

  describe '#nav_color' do
    it 'returns theme text, bg, border-b, and border classes' do
      result = helper.nav_color
      expect(result).to include('text-')
      expect(result).to include('bg-')
      expect(result).to include('border-b')
      expect(result).to include('border-')
    end
  end

  describe '#ui_tabs' do
    it 'returns tab-container class' do
      expect(helper.ui_tabs).to eq('tab-container')
    end
  end

  describe '#ui_tab' do
    it 'returns tab class' do
      expect(helper.ui_tab).to eq('tab')
    end
  end

  describe '#ui_active_tab' do
    it 'returns tab-active with theme text' do
      result = helper.ui_active_tab
      expect(result).to include('tab-active')
      expect(result).to include('text-')
    end
  end

  describe '#sidebar_link' do
    let(:path) { '/projects' }

    it 'returns base sidebar classes with hover tint' do
      allow(helper).to receive(:current_page?).with(path).and_return(false)

      result = helper.sidebar_link(path)

      expect(result).to include('flex items-center gap-x-2')
      expect(result).to include('rounded-md')
      expect(result).to include('hover:bg-violet-950/5')
      expect(result).to include('dark:hover:bg-violet-100/5')
    end

    it 'adds the active background for the current page' do
      allow(helper).to receive(:current_page?).with(path).and_return(true)

      result = helper.sidebar_link(path)

      expect(result).to include('bg-violet-950/5')
      expect(result).to include('dark:bg-violet-100/5')
    end
  end

  describe 'theme variations' do
    themes = {
      1 => 'gray',
      2 => 'indigo',
      3 => 'orange',
      4 => 'pink',
      5 => 'violet'
    }

    themes.each do |theme_id, theme_name|
      context "with #{theme_name} theme" do
        let(:user) { create(:user, theme: theme_id) }

        it 'returns correct bg classes' do
          result = helper.nav_color
          expect(result).to include("bg-#{theme_name}-")
          expect(result).to include("dark:bg-#{theme_name}-")
        end

        it 'returns correct text classes' do
          result = helper.nav_color
          expect(result).to include("text-#{theme_name}-")
          expect(result).to include("dark:text-#{theme_name}-")
        end

        it 'returns correct border classes' do
          result = helper.nav_color
          expect(result).to include("border-#{theme_name}-")
          expect(result).to include("dark:border-#{theme_name}-")
        end

        it 'returns correct sidebar link hover classes' do
          allow(helper).to receive(:current_page?).with('/projects').and_return(false)

          result = helper.sidebar_link('/projects')

          expect(result).to include("hover:bg-#{theme_name}-950/5")
          expect(result).to include("dark:hover:bg-#{theme_name}-100/5")
        end

        it 'returns correct sidebar link active classes' do
          allow(helper).to receive(:current_page?).with('/projects').and_return(true)

          result = helper.sidebar_link('/projects')

          expect(result).to include("bg-#{theme_name}-950/5")
          expect(result).to include("dark:bg-#{theme_name}-100/5")
        end
      end
    end
  end

  describe 'when no user is logged in' do
    before do
      allow(helper).to receive(:current_user).and_return(nil)
    end

    it 'defaults to violet theme' do
      result = helper.nav_color
      expect(result).to include('bg-violet-')
      expect(result).to include('text-violet-')
    end
  end
end
