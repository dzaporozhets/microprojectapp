require 'rails_helper'

RSpec.describe IconHelper, type: :helper do
  describe '#close_icon' do
    it 'renders an SVG element' do
      expect(helper.close_icon).to have_css('svg')
    end

    it 'defaults to h-5 w-5 size' do
      expect(helper.close_icon).to have_css('svg.h-5.w-5')
    end

    it 'accepts a custom size' do
      expect(helper.close_icon(size: 'h-4 w-4')).to have_css('svg.h-4.w-4')
    end
  end

  describe '#edit_icon' do
    it 'renders an SVG element' do
      expect(helper.edit_icon).to have_css('svg')
    end

    it 'defaults to h-5 w-5 size' do
      expect(helper.edit_icon).to have_css('svg.h-5.w-5')
    end

    it 'accepts a custom size' do
      expect(helper.edit_icon(size: 'h-4 w-4')).to have_css('svg.h-4.w-4')
    end
  end
end
