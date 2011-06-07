class Course < ActiveRecord::Base
  attr_accessible :name, :description, :hashed_password, :options
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :students
end
