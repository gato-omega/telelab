class Vlan < ActiveRecord::Base
  belongs_to :practica
  belongs_to :puerto
  belongs_to :endpoint, :class_name => 'Puerto'


  validates_presence_of :puerto_id, :endpoint_id, :practica_id
  validates :puerto_id, :uniqueness => {:scope => :practica_id}

  # Always puerto's logical endpoint's numero + 1 (because its the other side)
  # Starts at vlan number 2, 3 ... etc
  def numero
    the_port = self.puerto
    the_port.current_practica = self.practica
    the_port.current_vlan = self
    the_port.logical_endpoint.numero + 1
  end

end
