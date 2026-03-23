module MarkdownHelper
  def format_user_content(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true,
                                            link_attributes: { target: '_blank', rel: 'nofollow' })
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, fenced_code_blocks: true,
                                                 no_intra_emphasis: true, strikethrough: true, tables: true)
    markdown.render(text).html_safe # rubocop:disable Rails/OutputSafety -- escape_html: true prevents XSS
  end
end
