class Link < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :project, required: true

  #validates :title, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }

  def safe_title
    @safe_title ||= title.present? ? title : url
  end
end
