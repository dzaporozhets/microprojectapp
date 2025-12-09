class Comment < ApplicationRecord
  belongs_to :task, optional: false
  belongs_to :user, optional: false

  validates :body, presence: true

  mount_uploader :attachment, AttachmentUploader

  def image_attachment?
    attachment.content_type.start_with?('image/')
  end

  delegate :email, to: :user, prefix: true

  def removed?
    removed_at.present?
  end
end
