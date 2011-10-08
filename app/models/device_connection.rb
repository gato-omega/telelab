class DeviceConnection < ActiveRecord::Base
  belongs_to :puerto
  belongs_to :endpoint, :class_name => 'Puerto'


  #has_many :dispositivos, :through => :puertos
  #has_one :dispositivo, :through => :endpoint
  #has_one :dispositivo, :through => :puerto

  # Halves the results to aviod duplication on show (only for presentation matters)
  scope :without_duplicates, where('puerto_id < endpoint_id')

end
