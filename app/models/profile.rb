class Profile < ActiveRecord::Base
  belongs_to :user

  validates :firstname, :presence => true, :length => {:maximum => 30}
  validates :lastname, :presence => true, :length => {:maximum => 20}

  def name
    "#{self.firstname} #{self.lastname}"
  end

end
