namespace :conexiones do
  desc 'Create test logical conections for all open practices'
  task :create => :environment do
    Practica.where(:estado >> 'open').each do |practica|
      devices=practica.dispositivos
      puertos_matrix = []
      devices.each do |device|
        puertos_matrix << device.puertos_utiles
      end
    end
  end
end