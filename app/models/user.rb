class User < ApplicationRecord
  devise :two_factor_authenticatable
  class SignupsDisabledError < StandardError; end

  def self.disabled_signup?
    Rails.application.config.app_settings[:disable_signup]
  end

  app_settings = Rails.application.config.app_settings

  devise_modules = [:omniauthable]

  devise_modules += [
    :two_factor_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :lockable, :confirmable
  ] unless app_settings[:disable_email_login]

  devise *devise_modules, omniauth_providers: [:google_oauth2, :entra_id]

  mount_uploader :avatar, AvatarUploader

  after_create :create_personal_project
  after_create :create_sample_project, unless: -> { Rails.env.test? }

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

  THEMES = {
    1 => 'Gray',
    2 => 'Black',
    3 => 'Violet',
    4 => 'Lime',
    5 => 'Pink'
  }.freeze

  def self.available_themes
    THEMES
  end

  def theme_name
    THEMES[theme]
  end

  def theme_css_name
    theme_name&.downcase
  end

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
        # Update user uid and provider based on email
        user.update(uid: uid,
                    provider: provider,
                    oauth_avatar_url: image,
                    oauth_linked_at: Time.now)

        user.save
      end
    else
      # Check if sign-up is disabled for new users
      if User.disabled_signup?
        raise SignupsDisabledError, 'New registrations are currently disabled.'
      end

      user = User.new(provider: provider, uid: uid, email: email, created_from_oauth: true)
      user.oauth_avatar_url = image
      user.password = Devise.friendly_token[0, 20]
      user.disable_password = true
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.skip_confirmation_notification! if user.respond_to?(:skip_confirmation_notification!)
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
    Devise.mappings[:user].omniauthable? && Rails.application.config.app_settings[:google_client_id].present?
  end

  def oauth_user?
    self.uid.present? && self.provider.present?
  end

  def valid_password?(password)
    # Disable login with password if OAuth user
    return false if oauth_user?

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

  def img_url
    avatar&.url || oauth_avatar_url
  end

  def provider_human
    case provider
    when 'google_oauth2' then 'Google'
    when 'azure_activedirectory_v2', 'entra_id' then 'Microsoft'
    end
  end

  private

  def email_domain_check
    allowed_domain = Rails.application.config.app_settings[:app_allowed_email_domain]

    return true unless allowed_domain.present?

    unless email.end_with?("@#{allowed_domain}")
      errors.add(:email, "is not from an allowed domain.")
    end
  end
end
