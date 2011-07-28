class CreateDeviceConnections < ActiveRecord::Migration

  def self.up
    create_table :device_connections do |t|
      t.references :puerto
      t.references :endpoint
    end
  end

  def self.down
    drop_table :device_connections
  end
end
