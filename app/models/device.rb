class Device < ActiveRecord::Base
  has_many :ports
  has_many :connections, :through => :ports
  has_many :endpoints, :through => :connections
end
