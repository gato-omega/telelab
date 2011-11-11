class Practica < ActiveRecord::Base
  attr_accessor :user_list
  has_and_belongs_to_many :dispositivos
  has_and_belongs_to_many :users
  has_one :event, :dependent => :destroy, :as => :eventable
  
  has_many :vlans

  ESTADOS = %w[reserved open closed]


  before_save :check_event

  attr_reader :user_list

  def user_list=(ids)
    self.user_ids = ids.split(",")
  end

  def abrir
    update_attribute :estado, 'open'
  end

  def cerrar
    update_attribute :estado, 'closed'
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

  def check_event
    if self.event
    else
      self.create_event(:start => DateTime.now, :end => (DateTime.now + 1.hour))
    end
  end
end