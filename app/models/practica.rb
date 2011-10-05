class Practica < ActiveRecord::Base
  attr_accessor :user_list
  has_and_belongs_to_many :dispositivos
  has_and_belongs_to_many :users
  has_one :event
  attr_reader :user_list

  def user_list=(ids)
    self.user_ids = ids.split(",")
  end

end