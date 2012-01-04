class AddImageToPracticas < ActiveRecord::Migration
  def self.up
    add_column :practicas, :image, :string
  end

  def self.down
    remove_column :practicas, :image
  end
end
