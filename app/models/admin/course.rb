class Admin::Course < ActiveRecord::Base
  attr_accessible :name, :description, :matriculate_password
  validates :name, :presence => true

  ## Relationships

  

end