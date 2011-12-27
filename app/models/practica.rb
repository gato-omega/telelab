class Practica < ActiveRecord::Base

  ESTADOS = %w(reservada abierta cerrada)

  attr_accessor :user_list
  has_and_belongs_to_many :dispositivos

  has_and_belongs_to_many :teachers, :class_name => "User", :conditions => {:type => 'Teacher'}, :uniq => true
  has_and_belongs_to_many :students, :class_name => "User", :conditions => {:type => 'Student'}, :uniq => true
  has_and_belongs_to_many :users, :uniq => true
  
  has_one :event, :dependent => :destroy, :as => :eventable

  accepts_nested_attributes_for :event

  validates :name, :presence => true
  validates :estado, :presence => true, :inclusion => ESTADOS

  after_initialize :initialize_event

  has_many :vlans

  def puertos
    raise 'implement please!'
  end

  def self.exist_in_span(_start, _end)
    events = Event.where(((:start >= _start) & (:end <= _end)) | ((:start < _start) & (:end > _start)) | ((:start < _end) & (:end > _end)) | ((:start <= _start) & (:end >= _end)))
    events.map!{|event| event.eventable}
    events.select!{|eventable| eventable.is_a? Practica}
  end

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

  def start_humanized
    self.start.strftime '%B %e %Y | %l:%M %P'
  end
  
  def end_humanized
    self.end.strftime '%B %e %Y | %l:%M %P'
  end
  
  def tiempo
    "#{((self.end-self.start)/60).round} minutos"
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
