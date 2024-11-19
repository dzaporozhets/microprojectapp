class Project < ApplicationRecord
  FILE_LIMIT = 100
  PROJECT_LIMIT = 999
  ACTIVITY_LIMIT = 999

  belongs_to :user, required: true

  has_many :tasks, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :activities, dependent: :destroy

  has_many :pins, dependent: :destroy
  has_many :users_who_pinned, through: :pins, source: :user

  validates :name, presence: true, length: { maximum: 512 }
  validates :name, uniqueness: { scope: :user_id, message: "should be unique per user" }
  validates :user_id, presence: true

  validate :project_limit, on: :create
  validate :project_files_count_within_limit

  mount_uploaders :project_files, ProjectFileUploader

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :ordered_by_id, -> { order(id: :asc) }
  scope :ordered_by_id_desc, -> { order(id: :desc) }
  scope :without_personal, -> { where.not(name: 'Personal') }

  def personal?
    self.name == "Personal"
  end

  def team
    [user] + users
  end

  def find_user(user_id)
    return unless user_id

    team.find do |user|
      user.id == user_id.to_i
    end
  end

  def create_sample_tasks
    extra_params = {
      user_id: self.user_id,
      project_id: self.id
    }

    tasks = [
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

    tasks.each do |task|
      self.tasks.create(task.merge(extra_params))
    end
  end

  def create_sample_links
    extra_params = {
      user_id: self.user_id,
      project_id: self.id
    }

    links = [
      { url: "https://en.wikipedia.org/wiki/Project_management" },
      { url: "https://en.wikipedia.org/wiki/Time_management" },
    ]

    links.each do |link|
      self.links.create(link.merge(extra_params))
    end
  end

  def project_files_count_within_limit
    if project_files.count > FILE_LIMIT
      errors.add(:project_files, "exceeds the limit of #{FILE_LIMIT} files per project")
    end
  end

  def project_limit
    if user && user.projects.count >= PROJECT_LIMIT
      errors.add(:base, "You have reached the limit of #{PROJECT_LIMIT} projects.")
    end
  end

  def add_activity(user, action, trackable)
    unless personal? # add ability to enable/disable per project

      # Keep only ACTIVITY_LIMIT amount of records.
      # Remove older one after that
      if self.activities.count > ACTIVITY_LIMIT
        self.activities.order(id: :asc).first.delete
      end

      self.activities.create(
        user: user,
        action: action,
        trackable: trackable
      )
    end
  end

  def owner
    user
  end
end
