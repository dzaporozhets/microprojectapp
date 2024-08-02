require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:project) }

  it { should validate_presence_of(:url) }

  describe '#safe_title' do
    context 'when title is present' do
      it 'returns the title' do
        link = build(:link, title: 'Custom Title')
        expect(link.safe_title).to eq('Custom Title')
      end
    end

    context 'when title is not present' do
      it 'generates a title from the URL' do
        link = build(:link, title: nil, url: 'https://en.wikipedia.org/wiki/Time_management')
        expect(link.safe_title).to eq('Time Management')
      end

      it 'handles URLs with no path segments gracefully' do
        link = build(:link, title: nil, url: 'https://example.com/')
        expect(link.safe_title).to eq('https://example.com/')
      end

      it 'handles URLs with complex paths' do
        link = build(:link, title: nil, url: 'https://example.com/some/complex_path-here')
        expect(link.safe_title).to eq('Complex Path-here')
      end

      it 'handles URLs with file extension' do
        link = build(:link, title: nil, url: 'https://example.com/some/complex_path-here.pdf')
        expect(link.safe_title).to eq('Complex Path-here.pdf')
      end

      it 'handles URLs with underscores in path' do
        link = build(:link, title: nil, url: 'https://example.com/some_complex_path_here')
        expect(link.safe_title).to eq('Some Complex Path Here')
      end
    end
  end
end
