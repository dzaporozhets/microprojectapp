class Task < ApplicationRecord
  TASK_LIMIT = 2999

  belongs_to :project, required: true
  belongs_to :user, required: true
  belongs_to :assigned_user, class_name: 'User', optional: true
  belongs_to :document, optional: true

  has_many :comments, dependent: :destroy

  scope :todo, -> { where(done: false) }
  scope :done, -> { where(done: true) }
  scope :no_due_date, -> { where(due_date: nil) }
  scope :ordered_by_id, -> { order(id: :asc) }
  scope :basic_order, -> { order(star: :desc, created_at: :desc) }
  scope :order_by_star_then_old, -> { order(star: :desc, created_at: :asc) }

  validates :name, presence: true, length: { maximum: 512 }
  validates :user_id, presence: true
  validates :project_id, presence: true
  validate :task_limit, on: :create

  before_save :set_done_at, if: :done_changed?

  def self.group_by_projects
    self.includes(:project).group_by(&:project).sort_by { |project, _| project.name }
  end

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
