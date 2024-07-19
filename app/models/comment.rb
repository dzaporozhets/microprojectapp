class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  mount_uploader :attachment, AttachmentUploader

  def image_attachment?
    attachment.content_type.start_with?('image/')
  end
end
