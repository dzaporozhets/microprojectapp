class Note < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :project, optional: false

  has_paper_trail(
    only: [:content],
    on: [:update],
    version_limit: 4
  )

  scope :basic_order, -> { order(star: :desc, id: :desc) }

  validates :title, presence: true
  validate :acceptable_attachment

  has_one_attached :attachment

  private

  def acceptable_attachment
    return unless attachment.attached?

    errors.add(:attachment, 'is too large (max 5MB)') if attachment.blob.byte_size > 5.megabytes
  end
end
