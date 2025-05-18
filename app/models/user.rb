class User < ApplicationRecord
  class SignupsDisabledError < StandardError; end

  THEMES = {
    1 => 'Gray',
    2 => 'Indigo',
    3 => 'Lime',
    4 => 'Orange',
    5 => 'Pink',
    6 => 'Sky',
    7 => 'Violet'
  }.freeze

  # Set default theme to Violet (7)
  attribute :theme, default: 7

  OAUTH_PROVIDERS = {
    'google_oauth2' => 'Google',
    'azure_activedirectory_v2' => 'Microsoft',
    'entra_id' => 'Microsoft'
  }.freeze

  PASSWORD_RESET_THROTTLE = 5.minutes

  # Configuration
  app_settings = Rails.application.config.app_settings

  # Devise setup
  devise_modules = [:omniauthable]
  devise_modules += [
    :two_factor_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :lockable, :confirmable
  ] unless app_settings[:disable_email_login]

  devise *devise_modules, omniauth_providers: [:google_oauth2, :entra_id]
  devise :two_factor_authenticatable

  # Uploaders
  mount_uploader :avatar, AvatarUploader

  before_save :generate_otp_secret, if: -> { otp_required_for_login_changed? }
  before_create :ensure_calendar_token
  # Callbacks
  after_create :create_personal_project
  after_create :create_sample_project, unless: -> { Rails.env.test? }

  # Associations
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :assigned_tasks,
           class_name: 'Task',
           foreign_key: 'assigned_user_id',
           dependent: :nullify,
           inverse_of: :assigned_user
  has_many :project_users, dependent: :destroy
  has_many :invited_projects, through: :project_users, source: :project
  has_many :pins, dependent: :destroy
  has_many :pinned_projects, through: :pins, source: :project

  # Enums
  enum :dark_mode, { off: 0, on: 1, auto: 2 }

  # Scopes
  scope :admins, -> { where(admin: true) }

  # Validations
  validate :email_domain_check, on: :create

  #
  # Class methods
  #
  class << self
    def disabled_signup?
      Rails.application.config.app_settings[:disable_signup]
    end

    def available_themes
      THEMES
    end

    def from_omniauth(auth)
      uid = auth[:uid]
      provider = auth[:provider]
      email = auth[:email]
      image = auth[:image]

      return nil unless provider.present? && uid.present? && email.present?

      user = find_by(email: email)

      if user
        handle_existing_user_oauth(user, provider, uid, image)
      else
        create_user_from_oauth(provider, uid, email, image)
      end
    end

    private

    def handle_existing_user_oauth(user, provider, uid, image)
      if user.provider == provider && user.uid == uid
        # User logged in with provider before, nothing to do here
        user
      else
        # Update user uid and provider based on email
        user.update(
          uid: uid,
          provider: provider,
          oauth_avatar_url: image,
          oauth_linked_at: Time.current
        )

        # If user email is not confirmed, when connecting user we automatically
        # confirm their email address.
        if !user.confirmed? && user.respond_to?(:skip_confirmation!)
          user.skip_confirmation!
          user.save
        end

        user
      end
    end

    def create_user_from_oauth(provider, uid, email, image)
      # Check if sign-up is disabled for new users
      if disabled_signup?
        raise SignupsDisabledError, 'New registrations are currently disabled.'
      end

      user = new(
        provider: provider,
        uid: uid,
        email: email,
        created_from_oauth: true,
        oauth_avatar_url: image,
        password: Devise.friendly_token[0, 20],
        disable_password: true
      )

      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.skip_confirmation_notification! if user.respond_to?(:skip_confirmation_notification!)
      user.save

      user
    end
  end

  #
  # Authentication methods
  #
  def oauth_config?
    Devise.mappings[:user].omniauthable? &&
      Rails.application.config.app_settings[:google_client_id].present?
  end

  def oauth_user?
    uid.present? && provider.present?
  end

  def valid_password?(password)
    # Disable login with password if OAuth user
    return false if oauth_user?

    super
  end

  # Override Devise's send_reset_password_instructions method
  def send_reset_password_instructions
    if reset_password_sent_at && reset_password_sent_at > PASSWORD_RESET_THROTTLE
      # Skip sending instructions if the last request was less than 5 minutes ago
      errors.add(:email, 'Password reset request already sent, please check your email.')
      false
    else
      super
    end
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

  #
  # Project-related methods
  #
  def create_personal_project
    projects.find_or_create_by(name: "Personal")
  end

  def create_sample_project
    project = projects.create(name: "Sample")
    project.create_sample_tasks
    project.create_sample_links
    project
  end

  def personal_project
    @personal_project ||= projects.find_by(name: "Personal")
  end

  def personal_projects
    if personal_project.present?
      [personal_project]
    else
      []
    end
  end

  def all_active_projects
    personal_projects +
      projects.active.without_personal.ordered_by_id +
      invited_projects.active.ordered_by_id
  end

  def has_access_to?(project)
    projects.include?(project) || invited_projects.include?(project)
  end

  def owns?(project)
    self == project.user
  end

  #
  # UI and display methods
  #
  def theme_name
    THEMES[theme]
  end

  def theme_css_name
    theme_name&.downcase
  end

  def img_url
    avatar&.url || oauth_avatar_url
  end

  def provider_human
    OAUTH_PROVIDERS[provider]
  end

  #
  # Status methods
  #
  def invited?
    # TODO: Implement invitation logic
    false
  end

  def admin?
    admin
  end

  def created_today?
    created_at.to_date == Date.current
  end

  # Calendar token methods
  def regenerate_calendar_token!
    update!(calendar_token: generate_calendar_token)
  end

  private

  def ensure_calendar_token
    self.calendar_token ||= generate_calendar_token
  end

  def generate_calendar_token
    Digest::SHA256.hexdigest("#{email}:#{SecureRandom.hex(16)}:#{Time.current.to_i}")
  end

  def email_domain_check
    allowed_domain = Rails.application.config.app_settings[:app_allowed_email_domain]

    return true if allowed_domain.blank?

    unless email.end_with?("@#{allowed_domain}")
      errors.add(:email, "is not from an allowed domain.")
    end
  end
end
