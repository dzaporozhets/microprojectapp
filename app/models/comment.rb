class Comment < ApplicationRecord
  belongs_to :task, optional: false
  belongs_to :user, optional: false

  validates :body, presence: true

  mount_uploader :attachment, AttachmentUploader

  delegate :email, to: :user, prefix: true

  def removed?
    removed_at.present?
  end
end
