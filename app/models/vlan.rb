class Vlan < ActiveRecord::Base
  belongs_to :practica
  belongs_to :puerto
  belongs_to :endpoint, :class_name => 'Puerto'


  #validates_presence_of :numero, :puerto_id, :endpoint_id

end
