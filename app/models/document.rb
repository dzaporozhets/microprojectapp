class Document < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_many :tasks, dependent: :nullify

  has_paper_trail(
    only: [:title, :content],  # Track changes only for `title` and `content`
    on: [:update],             # Track changes only for updates
    version_limit: 10          # Keep only the last 10 changes
  )
end
