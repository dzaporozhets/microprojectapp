class Task < ApplicationRecord
  TASK_LIMIT = 1999

  belongs_to :project, required: true
  belongs_to :user, required: true

  has_many :comments, dependent: :destroy

  scope :todo, -> { where(done: false) }
  scope :done, -> { where(done: true) }
  scope :no_due_date, -> { where(due_date: nil) }
  scope :ordered_by_id, -> { order(id: :asc) }
  scope :basic_order, -> { order(star: :desc, created_at: :desc) }

  validates :name, presence: true
  validates :user_id, presence: true
  validates :project_id, presence: true
  validate :task_limit, on: :create

  before_save :set_done_at, if: :done_changed?

  private

  def task_limit
    if project && project.tasks.count >= TASK_LIMIT
      errors.add(:base, "This project has reached the limit of #{TASK_LIMIT} tasks.")
    end
  end

  def set_done_at
    self.done_at = Time.current if done && done_changed?(from: false, to: true)
  end
end
