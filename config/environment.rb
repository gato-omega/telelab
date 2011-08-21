# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Telelab02::Application.initialize!


# Embedded server! -- really against it
# FayeServer.instance.start


#When user signs in...do this
#Clear irc bot and release faye channel
Warden::Manager.after_authentication do |user, auth, opts|
  puts "###########################  SOMEONE LOGGED IN #{user.username}"
  #Find or create bot_manager singleton
  bot_manager = GBotManager.instance
  bot_manager.load_bot_for user
end

#When user signs out...do this
#Clear irc bot and release faye channel
Warden::Manager.before_logout do |user, auth, opts|
  #Find or create bot_manager singleton
  bot_manager = GBotManager.instance
  #Kill da bot for user
  bot_manager.kill_bot_for user
  puts "###########################  SOMEONE LOGGED OUT #{user.username}"
end


