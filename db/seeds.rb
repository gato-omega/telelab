# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
require "colorize"

puts "Initiating seeds...".yellow
###### usuarios

u_username = ["gacollazos", "mdiaz", "javhur", "teacher", "bob", "technician", "admin", "tech", "alice"]
#u_email = ["german.collazos@codescrum.com", "miguel.diaz@codescrum.com", "javhur@gmail.com", "teacher@teacher.com", "student@student.com", "technician@technician.com", "admin@admin.com"]
u_email = u_username.collect {|username| "#{username}@telelab.com"}
u_type = ["Admin", "Admin", "Teacher", "Teacher", "Student", "Technician", "Admin", "Technician", "Student"]

puts "Creating users...".yellow
u_username.size.times do |n|
  User.create(:username => u_username[n], :password => '123456', :email => u_email[n], :type => u_type[n], :options => {:faye => {}}, :profile_attributes => {:firstname => u_username[n], :lastname => u_username[n], :codigo => u_username[n].hash.to_s[1,8]})
  puts "  User #{u_username[n]} created".green
end

###### cursos

c_name = ["redes1", "redes2"]
c_description = ["descripcion1", "descripcion2"]
c_hashed_password = ["123456", "123456"]
c_options = [{:color1 => "red", :color2 => "green"},{:color1 => "blue", :color2 => "orange"}]

puts "Creating cursos...".yellow
c_name.size.times do |n|
  Course.create(:name => c_name[n], :description => c_description[n], :hashed_password => c_hashed_password[n], :options => c_options[n])
  puts "  Curso #{c_name[n]} created".green
end

###### dispositivos

d_nombre = ["Switch Catalyst VLAN", "Switch Catalyst 1", "Router Cisco 1", "Router Cisco 2", "Router Cisco 3", "Router Cisco 4", "Router Cisco 5", "Router Cisco 6"]
d_etiqueta = ["S2960_VLAN", "S_2960_1", "R_812_1", "R_812_2", "R_812_3", "R_812_4", "R_812_5", "R_812_6"]
d_categoria = ["switch", "switch", "router", "router", "router", "router","router", "router"]
d_tipo = ["vlan", "user", "user", "user", "user", "user","user", "user"]
d_estado = ["ok", "ok", "ok", "ok", "ok","ok", "bad", "stock"]

puts "Creating dispositivos...".yellow
dispositivos = []
cluster_id = 1
d_nombre.size.times do |n|
  dispositivos << Dispositivo.create(:nombre => d_nombre[n], :etiqueta => d_etiqueta[n], :categoria => d_categoria[n], :tipo => d_tipo[n], :estado => d_estado[n], :cluster_id => cluster_id)
  puts "  Dispositivo #{d_nombre[n]} created".green
end

vlan_switch = dispositivos[0]
switch_1 = dispositivos[1]
router_1 = dispositivos[2]
router_2 = dispositivos[3]
router_3 = dispositivos[4]
router_4 = dispositivos[5]
router_5 = dispositivos[6]
router_6 = dispositivos[7]

#puts "vlan_switch =  #{vlan_switch},  #{vlan_switch.class} "
#puts "switch_1 =  #{switch_1}, #{switch_1.class}"
#puts "router_1 =  #{router_1}"
#puts "router_2 =  #{router_2}"
#puts "router_3 =  #{router_3}"
#puts "router_4 =  #{router_4}, #{router_4.errors}"
#puts "router_5 =  #{router_5}"
#puts "router_6 =  #{router_6}"

###### puertos

#p_nombre = ["fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet 0/0", "fastEthernet 0/1", "fastEthernet", "fastEthernet", "fastEthernet", "fastEthernet"]
#p_etiqueta = ["1SC", "2SC", "1SC", "2SC", "1SN", "2SN", "1R3C", "2R3C", "1RC", "2RC", "FE_WinXP", "FE_WinXP", "Ubu_Eth0", "Deb_Eth0"]
#p_estado = ["ok", "ok", "bad", "ok", "ok", "ok", "ok", "ok", "ok", "ok", "bad", "ok", "ok", "ok"]
#p_dispositivo_id = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8, 9]

seed_puertos = [

    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'}, #  0
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'}, #  1
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'}, #  2
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'}, #  3
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/4", :etiqueta => "FE-05", :estado => 'ok'}, #  4
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/5", :etiqueta => "FE-06", :estado => 'ok'}, #  5
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/6", :etiqueta => "FE-07", :estado => 'ok'}, #  6
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 0/7", :etiqueta => "FE-08", :estado => 'ok'}, #  7

    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/0", :etiqueta => "FE-09", :estado => 'ok'}, #  8
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/1", :etiqueta => "FE-10", :estado => 'ok'}, #  9
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/2", :etiqueta => "FE-11", :estado => 'ok'}, # 10
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/3", :etiqueta => "FE-12", :estado => 'ok'}, # 11
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/4", :etiqueta => "FE-13", :estado => 'ok'}, # 12
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/5", :etiqueta => "FE-14", :estado => 'ok'}, # 13
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/6", :etiqueta => "FE-15", :estado => 'ok'}, # 14
    {:dispositivo => vlan_switch, :nombre => "fastEthernet 1/7", :etiqueta => "FE-16", :estado => 'ok'}, # 15

    {:dispositivo => switch_1, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 16
    {:dispositivo => switch_1, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 17
    {:dispositivo => switch_1, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 18
    {:dispositivo => switch_1, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 19

    {:dispositivo => router_1, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 20
    {:dispositivo => router_1, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 21
    {:dispositivo => router_1, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 22
    {:dispositivo => router_1, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 23

    {:dispositivo => router_2, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 24
    {:dispositivo => router_2, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 25
    {:dispositivo => router_2, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 26
    {:dispositivo => router_2, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 27

    {:dispositivo => router_3, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 28
    {:dispositivo => router_3, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 29
    {:dispositivo => router_3, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 30
    {:dispositivo => router_3, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 31

    {:dispositivo => router_4, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 32
    {:dispositivo => router_4, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 33
    {:dispositivo => router_4, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 34
    {:dispositivo => router_4, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 35

    {:dispositivo => router_5, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 36
    {:dispositivo => router_5, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 37
    {:dispositivo => router_5, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 38
    {:dispositivo => router_5, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 39

    {:dispositivo => router_6, :nombre => "fastEthernet 0/0", :etiqueta => "FE-01", :estado => 'ok'},    # 40
    {:dispositivo => router_6, :nombre => "fastEthernet 0/1", :etiqueta => "FE-02", :estado => 'ok'},    # 41
    {:dispositivo => router_6, :nombre => "fastEthernet 0/2", :etiqueta => "FE-03", :estado => 'ok'},    # 42
    {:dispositivo => router_6, :nombre => "fastEthernet 0/3", :etiqueta => "FE-04", :estado => 'ok'},    # 43

]

puts "Assigning puertos...".yellow
puertos = []
seed_puertos.each do |puerto|
  puertos << Puerto.create(puerto)
  puts "  Puerto #{puertos.last.dispositivo.etiqueta} - #{puertos.last.etiqueta} created".green
end

###### Conexiones fisicas
puts "Connecting physically...".yellow


# Router 1 to vlan
puertos[20].conectar_fisicamente puertos[0]
puertos[21].conectar_fisicamente puertos[1]
puertos[22].conectar_fisicamente puertos[2]
puertos[23].conectar_fisicamente puertos[3]

# Router 2 to vlan
puertos[24].conectar_fisicamente puertos[4]
puertos[25].conectar_fisicamente puertos[5]
puertos[26].conectar_fisicamente puertos[6]
puertos[27].conectar_fisicamente puertos[7]

# Router 3 to vlan
puertos[28].conectar_fisicamente puertos[8]
puertos[29].conectar_fisicamente puertos[9]
puertos[30].conectar_fisicamente puertos[10]
puertos[31].conectar_fisicamente puertos[11]

# Router 3 to vlan
puertos[32].conectar_fisicamente puertos[12]
puertos[33].conectar_fisicamente puertos[13]
puertos[34].conectar_fisicamente puertos[14]
puertos[35].conectar_fisicamente puertos[15]

#### OPEN PRACTICE +FOR DEVS
puts "Creating open practice...".yellow

open_practica = Practica.new
open_practica.name = "Practica de prueba"
open_practica.start = DateTime.now - 2.hours
open_practica.end = DateTime.now + 2.hours
open_practica.abrir
open_practica.users << User.all
open_practica.dispositivos << [router_1, router_2 , router_3, router_4]

if open_practica.save
  puts "EVERYTHING IS DONE!".light_green
else
  puts "FAILED TO CREATE PRACTICA".light_red
  puts "Practica >".yellow
  puts open_practica
  puts "Errors >".yellow
  puts open_practica.errors
end
puts "----------------------------------------------".yellow