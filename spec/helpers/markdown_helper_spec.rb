require 'rails_helper'

RSpec.describe MarkdownHelper, type: :helper do
  describe '#format_user_content' do
    it 'wraps plain text in a paragraph' do
      expect(helper.format_user_content('hello world')).to have_css('p', text: 'hello world')
    end

    it 'converts URLs to links' do
      result = helper.format_user_content('visit https://example.com today')

      expect(result).to have_link('https://example.com', href: 'https://example.com')
    end

    it 'escapes HTML tags instead of rendering them' do
      result = helper.format_user_content('<b>bold</b>')

      expect(result).to include('&lt;b&gt;')
      expect(result).not_to have_css('b')
    end

    it 'escapes script tags' do
      result = helper.format_user_content('<script>alert(1)</script>')

      expect(result).to include('&lt;script&gt;')
      expect(result).not_to include('<script>')
    end

    it 'escapes event handler attributes' do
      result = helper.format_user_content('<img src=x onerror=alert(1)>')

      expect(result).not_to have_css('img')
      expect(result).to include('&lt;img')
    end

    it 'preserves line breaks as separate paragraphs' do
      result = helper.format_user_content("first\n\nsecond")

      expect(result).to have_css('p', text: 'first')
      expect(result).to have_css('p', text: 'second')
    end

    it 'converts single newlines to line breaks' do
      result = helper.format_user_content("line one\nline two")

      expect(result).to include('<br>')
    end

    it 'renders markdown headings' do
      result = helper.format_user_content('# Title')

      expect(result).to have_css('h1', text: 'Title')
    end

    it 'renders markdown bold and italic' do
      result = helper.format_user_content('**bold** and *italic*')

      expect(result).to have_css('strong', text: 'bold')
      expect(result).to have_css('em', text: 'italic')
    end

    it 'renders fenced code blocks' do
      result = helper.format_user_content("```\ndef hello\n  puts 'hi'\nend\n```")

      expect(result).to have_css('pre code')
      expect(result).to include('def hello')
    end

    it 'renders inline code' do
      result = helper.format_user_content('use `method_name` here')

      expect(result).to have_css('code', text: 'method_name')
    end

    it 'renders markdown lists' do
      result = helper.format_user_content("- item one\n- item two")

      expect(result).to have_css('ul li', text: 'item one')
      expect(result).to have_css('ul li', text: 'item two')
    end

    it 'returns html safe string' do
      expect(helper.format_user_content('hello')).to be_html_safe
    end
  end
end
