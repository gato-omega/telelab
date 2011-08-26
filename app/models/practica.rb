class Practica < ActiveRecord::Base
  attr_accessor :user_list
  has_and_belongs_to_many :dispositivos
  has_and_belongs_to_many :users
  attr_reader :user_list

  def user_list=(ids)
    self.user_ids = ids.split(",")
  end

  #def start_at_string
  #  start.to_s(:db)
  #end
  #
  #def start_at_string=(start_to_str)
  #  self.start = Time.parse(start_to_str)
  #rescue ArgumentError
  #  @start_invalid = true
  #end
  #
  #def validate
  #  errors.add(:start, "is invalid") if @start_invalid
  #end

end