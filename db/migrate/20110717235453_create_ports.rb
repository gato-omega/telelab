class CreatePorts < ActiveRecord::Migration
  def self.up
    create_table :ports do |t|
      t.string :name
      t.string :tag
      t.string :state
      t.references :device

    end
  end

  def self.down
    drop_table :ports
  end
end
