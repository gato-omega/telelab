namespace :conexiones do

  desc 'Create test logical conections for all open practices'
  task :create => :environment do
    puts "Getting open practicas".light_green
    Practica.where(:estado >> 'open').each do |practica|
      puts "  Analizing #{practica.name}".yellow
      puertos_matrix = []
      devices=practica.dispositivos
      puts "  Number of devices = #{devices.size}".cyan

      devices.each do |device|
        p_utiles = device.puertos_utiles
        puts "    Device "+"#{device.nombre}".cyan + " has " + "#{p_utiles.size}".cyan + " ok ports"
        puertos_matrix << p_utiles
      end

      ready = false
      device_index_p = 0
      puerto_index_p = 0

      device_index_q = puertos_matrix.size - 1
      puerto_index_q = puertos_matrix[device_index_q].size - 1

      puts "  Connecting...".green
      until ready do
        p = puertos_matrix[device_index_p][puerto_index_p]
        q = puertos_matrix[device_index_q][puerto_index_q]

        puts p.inspect
        puts q.inspect

        #Connect p and q

        ready = true
      end

      puts "Results for " + "#{practica.name}".yellow + " are"
      Vlan.where(:practica_id >> practica.id).each do |vlan|
        puts "logical connection is #{vlan.inspect}"
      end

      puts "DONE!".green
    end
  end
end