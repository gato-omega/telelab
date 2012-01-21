class Message < ActiveRecord::Base
  belongs_to :practica
  belongs_to :dispositivo
  belongs_to :user

  validates :practica_id, :presence => true
  validates :dispositivo_id, :presence => true
  #validates :user_id, :presence => true # dont validate this!


  # Returns if the given message is comming from a device
  def incomming?
    device?
  end

  # Returns if the given message is sent to a device
  def outgoing?
    !outgoing?
  end

  # Returns if the given message is from a device
  def device?
    user.nil?
  end


  def user?
    !user.nil?
  end

  # Returns the direction of the message
  def direction
    incoming? ? :incomming : :outgoing
  end

end
