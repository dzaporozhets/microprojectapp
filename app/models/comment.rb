class Comment < ApplicationRecord
  belongs_to :task, optional: false
  belongs_to :user, optional: false

  validates :body, presence: true
  validate :acceptable_attachment

  has_one_attached :attachment

  delegate :email, to: :user, prefix: true

  def removed?
    removed_at.present?
  end

  private

  def acceptable_attachment
    return unless attachment.attached?

    errors.add(:attachment, 'is too large (max 5MB)') if attachment.blob.byte_size > 5.megabytes
  end
end
