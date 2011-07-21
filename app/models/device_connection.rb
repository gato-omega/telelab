class DeviceConnection < ActiveRecord::Base
  belongs_to :port
  belongs_to :endpoint, :class_name => 'Port'
end