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

end
