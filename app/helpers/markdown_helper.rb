module MarkdownHelper
  def format_user_content(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, fenced_code_blocks: true)
    markdown.render(text).html_safe # rubocop:disable Rails/OutputSafety -- escape_html: true prevents XSS
  end
end
