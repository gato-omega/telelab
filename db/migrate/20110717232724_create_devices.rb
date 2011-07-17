class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.string :name
      t.string :tag
      t.string :category
      t.string :type
      t.string :description
      t.string :usb

      t.timestamps
    end
  end

  def self.down
    drop_table :devices
  end
end
