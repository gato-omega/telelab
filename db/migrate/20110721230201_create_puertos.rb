class CreatePuertos < ActiveRecord::Migration
  def self.up
    create_table :puertos do |t|
      t.string :nombre
      t.string :etiqueta
      t.string :estado
      t.references :dispositivo
      t.references :device_connection
    end
  end

  def self.down
    drop_table :puertos
  end
end
