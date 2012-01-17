class AddStatusToDispositivos < ActiveRecord::Migration
  def self.up
    add_column :dispositivos, :status, :string
  end

  def self.down
    remove_column :dispositivos, :status
  end
end
