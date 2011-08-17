require 'cinch'
Dir["#{Rails.root}/lib/irc/*.rb"].each {|file| require file }
puts "\nGato-IRC Loaded !\n"