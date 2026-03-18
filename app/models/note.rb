class Note < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :project, optional: false

  validates :title, presence: true
end
