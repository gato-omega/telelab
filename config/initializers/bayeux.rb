require 'faye'
Dir["#{Rails.root}/lib/bayeux_middleware/*.rb"].each {|file| require file }
puts "\nGato-Bayeux Loaded !\n"