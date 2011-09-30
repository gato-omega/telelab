class AddOptionsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :options, :string
  end

  def self.down
    remove_column :users, :options
  end
end
