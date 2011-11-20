class Dispositivo < ActiveRecord::Base
  has_many :puertos, :include => :endpoint, :dependent => :destroy
  has_many :device_connections, :through => :puertos, :include => :dispositivo
  has_and_belongs_to_many :practicas

  #has_many :endpoints, :through => :device_connections
  #has_many :endpoints, :through => :device_connections, :class_name => 'Puerto', :source => :endpoint

  ## Constants

  # User - modifiable , VLAN - VLAN Switch

  TYPES = %w[user vlan]
  CATEGORIAS = %w[switch router]
  ESTADOS = %w[ok bad stock]

  validates :tipo, :presence => true
  validates :categoria, :presence => true

  accepts_nested_attributes_for :puertos

  # Returns only physically connected ports
  # @return [Array]
  def puertos_utiles
    puertos.select do |puerto|
      puerto.conectado_fisicamente?
    end
  end

  def recalcuate_port_numbers
    next_number = 0
    self.puertos.each do |puerto|
      next_number += 1
      puerto.numero = next_number
      puerto.save
    end
  end

end
