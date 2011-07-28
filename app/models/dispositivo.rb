class Dispositivo < ActiveRecord::Base
  has_many :puertos, :include => :endpoint
  has_many :device_connections, :through => :puertos, :include => :dispositivo

  #has_many :endpoints, :through => :device_connections
  #has_many :endpoints, :through => :device_connections, :class_name => 'Puerto', :source => :endpoint
end
