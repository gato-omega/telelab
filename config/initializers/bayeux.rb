require 'faye'
require File.expand_path("#{Rails.root}/lib/bayeux_middleware/faye_sender.rb", __FILE__)
require File.expand_path("#{Rails.root}/lib/bayeux_middleware/custom_faye_sender.rb", __FILE__)
#require "#{Rails.root}/lib/bayeux_middleware/custom_faye_sender"
puts "\nGato-Bayeux Loaded !\n"