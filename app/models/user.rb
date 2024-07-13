class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :omniauthable, omniauth_providers: [:google_oauth2]

  after_create :create_personal_project,
    :create_sample_project

  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :project_users, dependent: :destroy
  has_many :invited_projects, through: :project_users, source: :project

  scope :admins, -> { where(admin: true) }

  def self.from_omniauth(auth)
    uid = auth.uid
    provider = auth.provider
    email = auth.info.email

    return nil unless provider.present? && uid.present? && email.present?

    user = User.find_by(email: email)

    if user
      if user.provider == provider && user.uid == uid
        user
      else
        raise 'User with such email already exists'
      end
    else
      user = User.new(provider: provider, uid: uid, email: email)
      user.password = Devise.friendly_token[0,20]
      user.save
    end
  end

  def invited?
    # TODO
    false
  end

  def admin?
    self.admin
  end

  def owns?(project)
    self == project.user
  end

  def create_personal_project
    self.projects.find_or_create_by(name: "Personal")
  end

  def create_sample_project
    project = self.projects.create(name: "Sample")
    project.create_sample_tasks
    project.create_sample_links
    project
  end

  def personal_project
    @personal_project ||= self.projects.find_by(name: "Personal")
  end

  def has_access_to?(project)
    projects.include?(project) ||
      invited_projects.include?(project)
  end
end
