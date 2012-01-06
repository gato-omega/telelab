class AddDescriptionToPractica < ActiveRecord::Migration
  def self.up
    add_column :practicas, :description, :text
  end

  def self.down
    remove_column :practicas, :description
  end
end
