class User < ApplicationRecord
  def self.skip_email_confirmation?
    ENV['APP_EMAIL_CONFIRMATION'].blank?
  end

  devise_modules = [
    :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :lockable, :omniauthable
  ]

  unless skip_email_confirmation?
    devise_modules << :confirmable
  end

  devise *devise_modules, omniauth_providers: [:google_oauth2]

  after_create :create_personal_project
  after_create :create_sample_project, unless: -> { Rails.env.test? }

  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :project_users, dependent: :destroy
  has_many :invited_projects, through: :project_users, source: :project

  enum dark_mode: { off: 0, on: 1, auto: 2 }

  scope :admins, -> { where(admin: true) }

  validate :email_domain_check, on: :create

  def self.from_omniauth(auth)
    uid = auth.uid
    provider = auth.provider
    email = auth.info&.email

    return nil unless provider.present? && uid.present? && email.present?

    user = User.find_by(email: email)

    if user
      if user.provider == provider && user.uid == uid
        # User logged in with provider before, nothing to do here.
        user
      else
        # TODO: Decide if we want to prevent existing user link their
        # google account to local one. Maybe give them choice
        # raise 'User with such email already exists'
        user.update(uid: uid,
                    provider: provider,
                    avatar_url: auth.info&.image,
                    oauth_linked_at: Time.now)
      end
    else
      user = User.new(provider: provider, uid: uid, email: email, created_from_oauth: true)
      user.avatar_url = auth.info&.image
      user.password = Devise.friendly_token[0,20]
      user.disable_password = true
      user.skip_confirmation! if Devise.mappings[:user].confirmable?
      user.save
    end

    user
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

  def oauth_config?
    Devise.mappings[:user].omniauthable? && ENV['GOOGLE_CLIENT_ID'].present?
  end

  def oauth_user?
    self.uid.present? && self.provider.present?
  end

  def valid_password?(password)
    # Allow user to disable login with password when login with OAuth was used
    return false if disable_password && oauth_user? && oauth_config?

    super
  end

  # Override Devise's send_reset_password_instructions method
  def send_reset_password_instructions
    if reset_password_sent_at && reset_password_sent_at > 5.minutes.ago
      # Skip sending instructions if the last request was less than 5 minutes ago
      errors.add(:email, 'Password reset request already sent, please check your email.')
      false
    else
      super
    end
  end

  def all_active_projects
    [self.personal_project] +
      self.projects.active.without_personal.ordered_by_id +
      self.invited_projects.active.ordered_by_id
  end

  private

  def email_domain_check
    allowed_domain = ENV['APP_ALLOWED_EMAIL_DOMAIN']

    return true unless allowed_domain.present?

    unless email.end_with?("@#{allowed_domain}")
      errors.add(:email, "is not from an allowed domain.")
    end
  end
end
