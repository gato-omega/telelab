class Course < ActiveRecord::Base
  attr_accessible :name, :description, :hashed_password, :options
end
