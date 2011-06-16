class Profile < ActiveRecord::Base
  belongs_to :user

  #validates :firstname, :presence => true

  #attr_accessible :user_id, :firstname, :lastname
end
