# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Telelab02::Application.initialize!

#Load irc_init
require File.expand_path('../irc_init', __FILE__)