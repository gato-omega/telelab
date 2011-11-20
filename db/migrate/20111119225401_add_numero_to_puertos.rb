class AddNumeroToPuertos < ActiveRecord::Migration
  def self.up
    add_column :puertos, :numero, :integer

    # Initialize
    Dispositivo.all.each do |dispositivo|
      next_number = 0
      dispositivo.puertos.each do |puerto|
        next_number += 1
        puerto.numero = next_number
        puerto.save
      end
    end
  end

  def self.down
    remove_column :puertos, :numero
  end
end
