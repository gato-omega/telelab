class Course < ActiveRecord::Base
  attr_accessible :name, :description, :hashed_password, :options
  has_and_belongs_to_many :teachers, :join_table => 'users_courses'
  has_and_belongs_to_many :students, :join_table => 'users_courses'
end
