class User < ActiveRecord::Base
  has_many :patients
  has_many :patient_authorizations, :through => :patients
  belongs_to :organization
  accepts_nested_attributes_for :organization

  after_create :send_welcome_mail, :send_notification_mail
  def send_welcome_mail
     UserMailer.welcome_email(self).deliver
  end
  def send_notification_mail
     UserMailer.registration_email(self).deliver
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :organization_attributes

  ROLES = %w[therapist admin]

  #Calling this from the controller for multi-tenancy
  def self.get_users(current_org)
    current_org.users
  end

  def admin?
    self.role == 'admin'
  end
end
