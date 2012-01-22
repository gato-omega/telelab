require 'cinch'
#Dir["#{Rails.root}/lib/irc/*.rb"].each {|file| require file }
require File.expand_path("#{Rails.root}/lib/irc/g_bot.rb", __FILE__)
require File.expand_path("#{Rails.root}/lib/irc/irc_gateway.rb", __FILE__)
require File.expand_path("#{Rails.root}/lib/irc/remote_irc_gateway.rb", __FILE__)
puts "Gato-IRC Loaded !\n".green