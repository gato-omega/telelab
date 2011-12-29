class Course < ActiveRecord::Base

  #for storing hash in database
  serialize :options, Hash

  #attr_accessible :name, :description, :hashed_password, :options
  attr_accessor :password_confirmation
  attr_writer :password

  #has_and_belongs_to_many :teachers, :join_table => 'users_courses', :class_name => "User", :association_foreign_key=> "user_id", :conditions => {:type => 'Teacher'}, :uniq => true
  #has_and_belongs_to_many :students, :join_table => 'users_courses', :class_name => "User", :association_foreign_key=> "user_id", :conditions => {:type => 'Student'}, :uniq => true
  has_and_belongs_to_many :students, :join_table => 'users_courses', :association_foreign_key=> "user_id", :uniq => true
  has_and_belongs_to_many :teachers, :join_table => 'users_courses', :association_foreign_key=> "user_id", :uniq => true

  has_and_belongs_to_many :users, :join_table => 'users_courses'

  has_one :horario

  before_validation :options_hash_init
  validate :new_password?

  alias_attribute :the_password, :hashed_password

  def password
    the_password
  end

  private
  def options_hash_init
    if options.nil?
      options = {}
    elsif not options.is_a? Hash
      options = {}
    end
  end
  
  def new_password?
    unless password.eql? the_password
      if password.eql? password_confirmation
        self.the_password = password
      else
        errors.add :password_confirmation, 'does not match password'
      end
    end
    true
  end

end
