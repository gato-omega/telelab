class Horario < ActiveRecord::Base
  belongs_to :course
  has_many :bloques, :class_name => 'Event', :dependent => :destroy, :as => :eventable
end
