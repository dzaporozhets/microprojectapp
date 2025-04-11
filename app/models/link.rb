class Link < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :project, optional: false

  #validates :title, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }

  def safe_title
    @safe_title ||= (title.presence || title_from_url)
  end

  private

  def title_from_url
    uri = URI.parse(url)
    segments = uri.path.split('/')
    title_segment = segments.last
    title_text = title_segment ? title_segment.split(/[_-]/).map(&:capitalize).join(' ') : ''

    (title_text.presence || url)
  end
end
