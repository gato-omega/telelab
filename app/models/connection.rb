class Connection < ActiveRecord::Base
  has_one :port
  has_one :endpoint, :class_name => 'Port', :foreign_key => :endpoint
end
