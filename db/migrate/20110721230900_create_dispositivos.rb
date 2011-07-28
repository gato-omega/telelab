class CreateDispositivos < ActiveRecord::Migration
  def self.up
    create_table :dispositivos do |t|
      t.string :nombre
      t.string :etiqueta
      t.string :tipo
      t.string :categoria
      t.string :estado
      t.string :com
    end
  end

  def self.down
    drop_table :dispositivos
  end
end
