class Task < ApplicationRecord
  TASK_LIMIT = 3999

  belongs_to :project, optional: false
  belongs_to :user, optional: false
  belongs_to :assigned_user, class_name: 'User', optional: true
  belongs_to :note, optional: true

  has_many :comments, dependent: :destroy

  has_paper_trail(
    only: [:name, :description],
    on: [:update],
    version_limit: 5
  )

  scope :todo, -> { where(done: false) }
  scope :done, -> { where(done: true) }
  scope :no_due_date, -> { where(due_date: nil) }
  scope :with_due_date, -> { where.not(due_date: nil) }
  scope :ordered_by_id, -> { order(id: :asc) }
  scope :basic_order, -> { order(done: :asc, star: :desc, created_at: :desc) }
  scope :order_by_star_then_old, -> { order(star: :desc, created_at: :asc) }

  validates :name, presence: true, length: { maximum: 512 }
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
