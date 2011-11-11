class RemoveStartAndEndFromPracticas < ActiveRecord::Migration
  def self.up
    remove_column :practicas, :start
    remove_column :practicas, :end
  end

  def self.down
    add_column :practicas, :start, :datetime
    add_column :practicas, :end, :datetime
  end
end
