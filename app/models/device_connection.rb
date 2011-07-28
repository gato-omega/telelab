class DeviceConnection < ActiveRecord::Base
  belongs_to :puerto
  belongs_to :endpoint, :class_name => 'Puerto'


  #has_many :dispositivos, :through => :puertos
  #has_one :dispositivo, :through => :endpoint
  #has_one :dispositivo, :through => :puerto
end
