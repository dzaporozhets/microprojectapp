class Task < ApplicationRecord
  TASK_LIMIT = 1999

  belongs_to :project, required: true
  belongs_to :user, required: true

  scope :todo, -> { where(done: false) }
  scope :done, -> { where(done: true) }

  validates :name, presence: true
  validates :user_id, presence: true
  validates :project_id, presence: true
  validate :task_limit, on: :create

  private

  def task_limit
    if project && project.tasks.count >= TASK_LIMIT
      errors.add(:base, "This project has reached the limit of #{TASK_LIMIT} tasks.")
    end
  end
end
