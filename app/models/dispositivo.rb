class Dispositivo < ActiveRecord::Base
  has_many :puertos, :include => :endpoint, :dependent => :destroy
  has_many :device_connections, :through => :puertos, :include => :dispositivo
  has_and_belongs_to_many :practicas

  scope :for_users, where('tipo <> ?','vlan')
  scope :ok, where('estado = ?', 'ok')

  #has_many :endpoints, :through => :device_connections
  #has_many :endpoints, :through => :device_connections, :class_name => 'Puerto', :source => :endpoint

  ## Constants

  # User - modifiable , VLAN - VLAN Switch

  TYPES = %w[user vlan]
  CATEGORIAS = %w[switch router otro]
  ESTADOS = %w[ok bad stock]

  validates :tipo, :presence => true, :inclusion => TYPES
  validates :categoria, :presence => true, :inclusion => CATEGORIAS
  validates :cluster_id, :presence => true, :numericality => true

  accepts_nested_attributes_for :puertos

  # Returns only physically connected ports
  # @return [Array]
  def puertos_utiles
    puertos.select do |puerto|
      puerto.conectado_fisicamente?
    end
  end

  def number_of_puertos_utiles
    puertos_utiles.size
  end

  def irc_channel
    "#device_#{self.id}"
  end

  def recalculate_port_numbers
    self.puertos.each_with_index do |puerto, number|
      puerto.numero = number + 1
      puerto.save
    end
  end

  # TODO: Change the appropiate inital state, for now is ready
  state_machine :status, :initial => :ready do
    state :initializing
    state :reseting
    state :ready

    event :reset do
      transition all - :reseting => :reseting
    end

    event :do_boot do
      transition all - :initializing => :initializing
    end

    event :set_ready do
      transition all - :ready => :ready
    end

  end

  # Retrieves the current practica this device is on, if is not in a practica, returns nil
  def current_practica
    Practica.abiertas.search({:dispositivos_id_equals => self.id}, :join_type => :inner).first
  end
  
end
