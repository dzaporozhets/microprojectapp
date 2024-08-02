class Link < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :project, required: true

  #validates :title, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }

  def safe_title
    @safe_title ||= title.present? ? title : title_from_url
  end

  private

  def title_from_url
    uri = URI.parse(url)
    segments = uri.path.split('/')
    title_segment = segments.last
    title_text = title_segment ? title_segment.split(/[_-]/).map(&:capitalize).join(' ') : ''

    if title_text.present?
      title_text
    else
      url
    end
  end
end
