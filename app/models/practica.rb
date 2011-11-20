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

  attr_reader :user_list

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

  scope :open, where(:estado => 'open')
  scope :closed, where(:estado => 'closed')
  scope :reserved, where(:estado => 'reserved')

  state_machine :estado, :initial => :reserved do
    state :reserved
    state :open
    state :closed

    event :open do
      transition all => :open
    end

    event :close do
      transition all => :closed
    end
  end

  private
  def initialize_event
    self.build_event(:start => DateTime.now, :end => (DateTime.now + 1.hour))
  end

end
