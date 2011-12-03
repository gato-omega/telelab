class Profile < ActiveRecord::Base
  belongs_to :user

  def name
    "#{self.firstname} #{self.lastname}"
  end

end
