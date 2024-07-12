class Task < ApplicationRecord
  belongs_to :project, required: true
  belongs_to :user, required: true

  scope :todo, -> { where(done: false) }
  scope :done, -> { where(done: true) }

  validates :name, presence: true
  validates :user_id, presence: true
  validates :project_id, presence: true
end
