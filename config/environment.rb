# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Telelab02::Application.initialize!

begin
  IRCGateway.instance
  puts 'IRCGateway initialized'
rescue
  puts 'COULD NOT INITIALIZE IRC GATEWAY'
end

# Warden hooks
Warden::Manager.after_authentication do |user,auth,opts|
  puts "Someone logged in> #{user.username}"
end

Warden::Manager.before_logout do |user,auth,opts|
  puts "Someone logged out> #{user.username}"
end