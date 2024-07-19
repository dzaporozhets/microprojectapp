class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :body, presence: true

  mount_uploader :attachment, AttachmentUploader

  def image_attachment?
    attachment.content_type.start_with?('image/')
  end

  def user_email
    user.email
  end
end
