#require File.expand_path("#{Rails.root}/config/initializers/load_app_config.rb", __FILE__)
#Dir["#{Rails.root}/lib/bayeux_irc_middleware/*.rb"].each {|file| require file }

class GBotManager < Hash

  include Singleton
  attr_accessor :config

  #Starts all unstarted bots
  def start_all
    each do |id, bot|
      Thread.new do
        if !bot.connected?
          bot.start
        end
      end
    end
  end

  #Quits and removes all
  def kill_all
    each do |id, bot|
      if bot.connected?
        bot.quit
      end
    end
    self.clear
  end

  #Disconnects the bot with id id
  def disconnect(id)
    [id].quit
  end

  #Disconnects and removes bot with id id
  def kill_bot_for(user)
    bot_key = "uid_#{user.id}".to_sym
    bot = self[bot_key]
    if bot
      if bot.class.eql? GBot and bot.connected?
        (self.delete bot_key).quit
      else
        self.delete bot_key
      end
    end
  end

  #Loads/creates the bot for the specified user, associating them
  def load_bot_for(user)

    bot_key = "uid_#{user.id}".to_sym
    if self[bot_key] #exists
      self[bot_key]
    else #load new!

         #Load config
      load_irc_config
      irc_config = @config
      bot = GBot.new do

        configure do |c|
          c.server = irc_config[:server][:ip]#'127.0.0.1'#
          c.nick = "#{irc_config[:client][:nick_prefix]}#{user.username}"
          c.channels = irc_config[:client][:default_channels]
        end

        #Listen and do...
        on :message do |m|
          mensaje_raw_real = "$('#irc_area').append(\"#{m.message}\n\");"
          canal = "#{FAYE_CHANNEL_PREFIX}#{user.username}"
          bot.send_via_faye canal, (bot.escape_javascript mensaje_raw_real)
        end
      end

      #The new thread for da bot
      Thread.new do
        bot.start
      end

      #include in self for reference
      self[bot_key] = bot
    end
  end

  private
  #Loads irc config in @config
  def load_irc_config(force_reload = false)
    if not @config and not force_reload
      @config=APP_CONFIG[:irc]
      @config[:client][:default_channels].collect! {|channel| "##{channel}"}
    end
  end
end