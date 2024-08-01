class Comment < ApplicationRecord
  belongs_to :task, required: true
  belongs_to :user, required: true

  validates :body, presence: true

  mount_uploader :attachment, AttachmentUploader

  def image_attachment?
    attachment.content_type.start_with?('image/')
  end

  def user_email
    user.email
  end
end
