# frozen_string_literal: true

class Project < ApplicationRecord
  # Constants
  PROJECT_LIMIT = 999
  ACTIVITY_LIMIT = 999
  PERSONAL_PROJECT_NAME = 'Personal'

  # Associations
  belongs_to :user, optional: false

  has_many :tasks, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :activities, dependent: :destroy
  has_many :pins, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 512 }
  validates :name, uniqueness: { scope: :user_id, message: "should be unique per user" }

  validate :project_limit, on: :create

  # Uploaders
  mount_uploaders :project_files, ProjectFileUploader

  # Scopes
  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :ordered_by_id, -> { order(id: :asc) }
  scope :without_personal, -> { where.not(name: PERSONAL_PROJECT_NAME) }

  # Project type methods
  def personal?
    name == PERSONAL_PROJECT_NAME
  end

  # Team methods
  def team
    [user] + users
  end

  def has_team?
    users.any?
  end

  def overdue_tasks?
    tasks.todo.with_due_date.exists?(due_date: ...Date.current)
  end

  def find_user(user_id)
    return if user_id.blank?

    user_id = user_id.to_i
    # Use more efficient lookup if the user is the owner
    return user if user.id == user_id

    # Use ActiveRecord's find method for better performance
    users.find_by(id: user_id)
  end

  alias_method :owner, :user

  # Sample data methods
  def create_sample_tasks
    return false unless persisted?

    common_params = {
      user_id: user_id,
      project_id: id
    }

    sample_tasks_data.each do |task_data|
      tasks.create(task_data.merge(common_params))
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to create sample tasks: #{e.message}")
    false
  end

  # Validation methods
  def project_limit
    return unless user && user.projects.count >= PROJECT_LIMIT

    errors.add(:base, "You have reached the limit of #{PROJECT_LIMIT} projects.")
  end

  # Activity tracking
  def add_activity(user, action, trackable)
    return if personal? # add ability to enable/disable per project

    # Use transaction to ensure data consistency
    Activity.transaction do
      # More efficient batch deletion if needed
      if activities.count >= ACTIVITY_LIMIT
        oldest_ids = activities.order(id: :asc).limit(activities.count - ACTIVITY_LIMIT + 1).pluck(:id)
        Activity.where(id: oldest_ids).delete_all if oldest_ids.any?
      end

      activities.create!(
        user: user,
        action: action,
        trackable: trackable
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to add activity: #{e.message}")
    false
  end

  private

  def sample_tasks_data
    [
      { name: "Grocery shopping for weekly supplies" },
      { name: "Finish annual financial report for manager" },
      { name: "Thoroughly clean the entire house" },
      { name: "Prepare comprehensive project meeting presentation", due_date: Date.current },
      { name: "Book doctor appointment for next Monday" },
      { name: "Update website with new content and features", due_date: 1.week.from_now.to_date },
      { name: "Organize and lead team meeting on project progress" },
      { name: "Pay monthly electricity and water bills online" },
      { name: "One-hour workout session at the gym", star: true },
      { name: "Read initial chapters of the book", done: true },
      { name: "Follow up with client on project proposal" },
      { name: "Plan and book summer vacation destinations" },
      { name: "Sort and organize computer files", done: true },
      { name: "Draft and publish blog post on productivity tips" }
    ]
  end

end
