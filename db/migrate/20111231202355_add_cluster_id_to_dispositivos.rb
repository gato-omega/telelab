class AddClusterIdToDispositivos < ActiveRecord::Migration
  def self.up
    add_column :dispositivos, :cluster_id, :integer
  end

  def self.down
    remove_column :dispositivos, :cluster_id
  end
end
