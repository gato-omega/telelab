class RemoveDeviceConnectionFromPuerto < ActiveRecord::Migration
  def self.up
    remove_column :puertos, :dispositivo_id
  end

  def self.down
    change_table :puertos do |t|
      t.references :dispositivo
    end
  end
end
