class Port < ActiveRecord::Base
  belongs_to :device
  has_one :connection
  has_one :endpoint, :through => :connection, :class_name => 'Port'
end
