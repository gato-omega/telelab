class RemoveDeviceConnectionFromPuerto < ActiveRecord::Migration
  def self.up
    remove_column :puertos, :device_connection_id
  end

  def self.down
    change_table :puertos do |t|
      t.references :device_connection_id
    end
  end
end
