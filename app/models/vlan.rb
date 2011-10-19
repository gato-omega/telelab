class Vlan < ActiveRecord::Base
  belongs_to :practica
  belongs_to :puerto
  belongs_to :endpoint, :class_name => 'Puerto'


  validates_presence_of :puerto_id, :endpoint_id, :practica_id
  validates :puerto_id, :uniqueness => {:scope => :practica_id}

  before_validation :assign_number

  def assign_number
    numero = 1

    Vlan.where(:practica_id >> self.practica_id).order(:numero).in_groups_of(2) do |group|
      pvlan_a = group[0]
      pvlan_b = group[1]

      if pvlan_a
        numero=pvlan_a.numero+1
        if pvlan_b && numero < pvlan_b.numero
          break
        end
      end
    end
    self.numero = numero
  end
  

end
