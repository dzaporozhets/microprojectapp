class User < ApplicationRecord
  devise :two_factor_authenticatable
  class SignupsDisabledError < StandardError; end

  def self.skip_email_confirmation?
    ENV['APP_SKIP_EMAIL_CONFIRMATION'].present?
  end

  def self.disabled_signup?
    ENV['APP_DISABLE_SIGNUP'].present?
  end

  devise_modules = [
    :two_factor_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :lockable, :omniauthable, :confirmable
  ]

  devise *devise_modules, omniauth_providers: [:google_oauth2, :azure_activedirectory_v2]

  mount_uploader :avatar, AvatarUploader

  after_create :create_personal_project
  after_create :create_sample_project, unless: -> { Rails.env.test? }

  # In case the app is configured to skip email confirmation
  before_create :skip_email_confirmation, if: -> { User.skip_email_confirmation? }
  before_update :confirm_email_changed, if: -> { User.skip_email_confirmation? }

  before_save :generate_otp_secret, if: -> { otp_required_for_login_changed? }

  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy

  has_many :assigned_tasks,
    class_name: 'Task',
    foreign_key: 'assigned_user_id',
    dependent: :nullify

  has_many :project_users, dependent: :destroy
  has_many :invited_projects, through: :project_users, source: :project

  has_many :pins, dependent: :destroy
  has_many :pinned_projects, through: :pins, source: :project

  enum dark_mode: { off: 0, on: 1, auto: 2 }

  scope :admins, -> { where(admin: true) }

  validate :email_domain_check, on: :create

  def self.from_omniauth(auth)
    uid = auth[:uid]
    provider = auth[:provider]
    email = auth[:email]
    image = auth[:image]

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
                    avatar_url: image,
                    oauth_linked_at: Time.now)

        user.save
      end
    else
      # Check if sign-up is disabled for new users
      if User.disabled_signup?
        raise SignupsDisabledError, 'New registrations are currently disabled.'
      end

      user = User.new(provider: provider, uid: uid, email: email, created_from_oauth: true)
      user.avatar_url = image
      user.password = Devise.friendly_token[0,20]
      user.disable_password = true
      user.skip_confirmation!
      user.skip_confirmation_notification!
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

  def created_today?
    created_at.to_date == Date.current
  end

  def skip_email_confirmation
    self.skip_confirmation!
    self.skip_confirmation_notification!
  end

  def confirm_email_changed
    self.confirm if self.unconfirmed_email_changed?
  end

  def two_factor_enabled?
    otp_required_for_login
  end

  def generate_otp_secret
    if otp_required_for_login
      self.otp_secret ||= User.generate_otp_secret
    else
      self.otp_secret = nil
    end
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
