class Practica < ActiveRecord::Base
  attr_accessor :user_list
  has_and_belongs_to_many :dispositivos
  has_and_belongs_to_many :users
  has_one :event

  has_many :vlans

  ESTADOS = %w[reserved open closed]


  attr_reader :user_list

  def user_list=(ids)
    self.user_ids = ids.split(",")
  end

  def abrir
    update_attribute :estado, 'open'
  end

  def cerrar
    update_attribute :estado, 'closed'
  end
end