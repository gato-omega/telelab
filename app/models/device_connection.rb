class DeviceConnection < ActiveRecord::Base
  belongs_to :puerto
  belongs_to :endpoint, :class_name => 'Puerto'


  #has_many :dispositivos, :through => :puertos
  #has_one :dispositivo, :through => :endpoint
  #has_one :dispositivo, :through => :puerto

  # Halves the results to avoid duplication on show (only for presentation matters)
  scope :without_duplicates, where('puerto_id < endpoint_id')

  validate :not_the_same_port

  def fullname
    "#{Dispositivo.find(puerto.dispositivo_id).etiqueta} - #{puerto.etiqueta} * #{Dispositivo.find(endpoint.dispositivo_id).etiqueta} - #{endpoint.etiqueta}"
  end

  private
  def not_the_same_port
    if (puerto.eql? endpoint)
      errors.add(:puerto,'puerto is the same as endpoint')
      false
    else
      true
    end
  end

end
