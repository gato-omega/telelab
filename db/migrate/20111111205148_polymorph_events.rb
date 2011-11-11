class PolymorphEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :eventable_id, :integer
    add_column :events, :eventable_type, :string
    remove_column :events, :practica_id
  end

  def self.down
    remove_column :events, :eventable_id
    remove_column :events, :eventable_type
    add_column :events, :practica_id, :integer
  end
end
