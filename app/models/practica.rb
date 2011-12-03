class Practica < ActiveRecord::Base
  attr_accessor :user_list
  has_and_belongs_to_many :dispositivos
  has_and_belongs_to_many :users
  has_one :event, :dependent => :destroy, :as => :eventable

  accepts_nested_attributes_for :event

  after_initialize do
    initialize_event
  end

  has_many :vlans

  def user_list=(ids)
    self.user_ids = ids.split(",")
  end

  def start
    self.event.start
  end

  def end
    self.event.end
  end

  def start=(start_time)
    self.event.start = start_time
  end

  def end=(end_time)
    self.event.end = end_time
  end

  scope :openned, where(:estado => 'abierta')
  scope :closed, where(:estado => 'cerrada')
  scope :reserved, where(:estado => 'reservada')

  state_machine :estado, :initial => :reservada do
    state :reservada
    state :abierta
    state :cerrada

    event :abrir do
      transition all => :abierta
    end

    event :cerrar do
      transition all => :cerrada
    end

    event :reservar do
      transition all => :reservada
    end
  end

  private
  def initialize_event
    self.build_event(:start => DateTime.now, :end => (DateTime.now + 1.hour)) unless event
  end

end
