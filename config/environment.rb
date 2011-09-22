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
