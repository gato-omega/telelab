class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable //ELIMINATED, put again if needed  :confirmable, :registerable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :type, :email, :password, :password_confirmation, :remember_me


  ## The following are the relationships

  has_and_belongs_to_many :practicas

  ## PROFILE
  has_one :profile, :dependent => :destroy

  accepts_nested_attributes_for :profile
  attr_accessible :profile_attributes

  ## Methods

  #return an array [User, User, ...], instead of [Admin, Student, Student, Teacher, ...]
  def self.all_without_typecast
    self.all.collect! do |u|
      u.becomes(User)
    end
  end

  #makes subclasses of User (Admin, Teacher, ...) into User class
  def userize
    self.becomes(User)
  end

  def require_password?
    new_record?
  end

  def chat_status(channel)
    options[:faye][channel] ? options[:faye][channel] : :offline
  end

  def clear_chat_statuses
    update_attribute :options, {:faye => {}}
  end

  def name
    self.profile.name
  end


  ## Custom validations

  validates :type, :presence => true


  ## Constants

  ROLES = %w[Admin Teacher Technician Student]

  ################################################################################################
  ## Added by gato -- add sign in by username or email

  attr_accessor :login
  validates :username, :uniqueness => true, :presence => true

  #for storing hash in database
  serialize :options, Hash
  attr_accessible :options
  validate :options_hash_init


  ### PROTECTED
  protected


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", {:value => login}]).first
  end

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = where(attributes).first
      end
    end

    unless record
      record = new
      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

  def self.find_record(login)
    where(["username = :value OR email = :value", {:value => login}]).first
  end

  # CUSTOM PROTECTED

  def options_hash_init
    self.options = {:faye => {}} unless self.options.is_a? Hash
    true
  end

end
