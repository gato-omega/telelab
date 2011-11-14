class Course < ActiveRecord::Base

  #for storing hash in database
  serialize :options, Hash

  #attr_accessible :name, :description, :hashed_password, :options

  has_and_belongs_to_many :teachers, :join_table => 'users_courses', :class_name => "User", :association_foreign_key=> "user_id", :conditions => {:type => 'Teacher'}
  has_and_belongs_to_many :students, :join_table => 'users_courses', :class_name => "User", :association_foreign_key=> "user_id", :conditions => {:type => 'Student'}

  has_one :horario

  before_validation :options_hash_init
  private
  def options_hash_init
    if options.nil?
      options = {}
    elsif not options.is_a? Hash
      options = {}
    end
  end

end
