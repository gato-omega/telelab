# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

###### usuarios

u_username = ["gacollazos", "mdiaz", "javhur", "teacher", "student", "technician", "admin"]
u_pass = ["123456", "123456", "123456", "123456", "123456", "123456", "123456"]
u_email = ["german.collazos@codescrum.com", "miguel.diaz@codescrum.com", "javhur@gmail.com", "teacher@teacher.com", "student@student.com", "technician@technician.com", "admin@admin.com"]
u_type = ["Admin", "Admin", "Teacher", "Teacher", "Student", "Technician", "Admin"]

7.times do |n|
  User.create(:username => u_username[n], :password => u_pass[n], :email => u_email[n], :type => u_type[n], :profile_attributes => {:firstname => u_username[n], :lastname => u_username[n], :codigo => " "})

end

###### cursos

c_name = ["redes1", "redes2"]
c_description = ["descripcion1", "descripcion2"]
c_hashed_password = ["qwerty", "asdfgh"]
c_options = {:color1 => "red", :color2 => "green"}

2.times do |n|
  Course.create(:name => c_name[n], :description => c_description[n], :hashed_password => c_hashed_password[n], :options => c_options)
end

###### dispositivos

d_nombre = ["Switch Catalyst", "Switch Catalyst", "Switch Nortel", "Router 3Com", "Router Cisco", "WinXP VM", "Win7 VM", "Ubuntu VM", "Debian VM"]
d_etiqueta = ["S_2960", "S_2960", "S_2526T", "R_812", "R_827", "WinXP VM","Win7 VM", "Ubuntu VM", "Dedian VM"]
d_categoria = ["Switch", "Switch", "Switch", "Router", "Router", "VM","VM", "VM", "VM"]
d_tipo = ["system", "system", "user", "user", "user", "user","user", "user", "user"]
d_estado = ["ok", "ok", "bad", "ok", "ok", "ok", "ok", "ok", "stock"]

9.times do |n|
  Dispositivo.create(:nombre => d_nombre[n], :etiqueta => d_etiqueta[n], :categoria => d_categoria[n], :tipo => d_tipo[n], :estado => d_estado[n])
end

###### puertos

p_nombre = ["fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet", "fastEthernet", "fastEthernet", "fastEthernet"]
p_etiqueta = ["1SC", "2SC", "1SC", "2SC", "1SN", "2SN", "1R3C", "2R3C", "1RC", "2RC", "FE_WinXP", "FE_WinXP", "Ubu_Eth0", "Deb_Eth0"]
p_estado = ["ok", "ok", "bad", "ok", "ok", "ok", "ok", "ok", "ok", "ok", "bad", "ok", "ok", "ok"]
p_dispositivo_id = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8, 9]

14.times do |n|
  Puerto.create(:nombre => p_nombre[n], :etiqueta => p_etiqueta[n], :estado => p_estado[n], :dispositivo_id => p_dispositivo_id[n])
end