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
  validates_presence_of :dispositivos

  # Delayed Jobs
  before_validation :apply_time_safety
  after_create :manage_delayed_transitions_on_create
  before_update :manage_delayed_transitions_on_update
  after_destroy :clear_delayed_jobs

  #Image
  mount_uploader :image, ImageUploader

  # Event
  after_initialize :initialize_event

  # Vlans
  has_many :vlans, :dependent => :destroy

  # puertos of the practica
  def puertos
    raise 'implement please!'
  end

  # TODO: Complete this when possible
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

  def finishes_in
    (self.end - DateTime.now).to_i
  end

  def starts_in
    (self.start.localtime - DateTime.now).to_i
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

  # Trims practicas so that a lapse of time exists for device reset an stuff
  # The actual separation is 2*span, because span is put left and right
  def apply_time_safety(span = 2.minutes)
    if self.new_record?
      puts "applying time safety with #{span}"
      self.start += span
      self.end -= span
    end
  end

  private
  def manage_delayed_transitions_on_create
    openning_time = self.start - self.created_at
    closing_time = openning_time + (self.end - self.start)
    Delayed::Job.enqueue(PracticeJob.new(self.id, :open), 0, openning_time.seconds.from_now)
    Delayed::Job.enqueue(PracticeJob.new(self.id, :close), 0, closing_time.seconds.from_now)
  end

  def manage_delayed_transitions_on_update
    unless self.new_record? # Work only after existance
      jobs = Delayed::Job.where("handler like ?", "%practice_id: #{self.id}%")
      jobs.each do |job|
        if job.handler.include? 'open'
          job.update_attribute(:run_at, self.start)
        elsif job.handler.include? 'close'
          job.update_attribute(:run_at, self.end)
        end
      end
    end
  end

  def clear_delayed_jobs
    Delayed::Job.where("handler like ?", "%practice_id: #{self.id}%").destroy_all
  end

  def initialize_event
    self.build_event(:start => DateTime.now, :end => (DateTime.now + 1.hour)) unless event
  end

end
