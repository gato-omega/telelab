class RemoveNumeroFromVlans < ActiveRecord::Migration
  def self.up
    remove_column :vlans, :numero
  end

  def self.down
    add_column :vlans, :numero, :integer
  end
end
