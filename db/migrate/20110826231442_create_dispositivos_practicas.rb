class CreateDispositivosPracticas < ActiveRecord::Migration
  def self.up
    create_table :dispositivos_practicas, :id => false do |t|
      t.references :dispositivo
      t.references :practica
    end
  end

  def self.down
    drop_table :dispositivos_practicas
  end
end