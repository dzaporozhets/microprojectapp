class Project < ApplicationRecord
  FILE_LIMITS = 100

  belongs_to :user, required: true

  has_many :tasks, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id, message: "should be unique per user" }
  validates :user_id, presence: true

  validate :project_files_count_within_limit

  mount_uploaders :project_files, ProjectFileUploader


  def personal?
    self.name == "Personal"
  end

  def team
    [user] + users
  end

  def create_sample_tasks
    extra_params = {
      user_id: self.user_id,
      project_id: self.id
    }

    tasks = [
      { name: "Grocery Shopping", description: "Buy milk, eggs, bread, and fruits from the supermarket" },
      { name: "Finish Report", description: "Complete the annual financial report and send it to the manager" },
      { name: "Clean the House", description: "Vacuum the living room and clean the kitchen" },
      { name: "Prepare Presentation", description: "Create slides for the upcoming project meeting" },
      { name: "Book Doctor Appointment", description: "Schedule a check-up with Dr. Smith for next Monday" },
      { name: "Update Website", description: "Add new blog post and update the homepage banner" },
      { name: "Team Meeting", description: "Organize a team meeting to discuss project progress" },
      { name: "Pay Bills", description: "Pay electricity and water bills online" },
      { name: "Workout Session", description: "Go to the gym for a 1-hour workout session" },
      { name: "Read Book", description: "Read the first three chapters of 'Atomic Habits'" },
      { name: "Client Follow-Up", description: "Email the client to follow up on the project proposal" },
      { name: "Plan Vacation", description: "Research destinations and book flights for the summer vacation" },
      { name: "Organize Files", description: "Sort and organize files on the computer" },
      { name: "Write Blog Post", description: "Draft and publish a new blog post about productivity tips" }
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
      { title: "https://en.wikipedia.org/wiki/Project_management", url: "https://en.wikipedia.org/wiki/Project_management" },
      { title: "https://en.wikipedia.org/wiki/Time_management", url: "https://en.wikipedia.org/wiki/Time_management" },
    ]

    links.each do |link|
      self.links.create(link.merge(extra_params))
    end
  end

  def project_files_count_within_limit
    if project_files.count > FILE_LIMITS
      errors.add(:project_files, "exceeds the limit of #{FILE_LIMITS} files per project")
    end
  end
end
