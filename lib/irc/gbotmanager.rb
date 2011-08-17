class GbotManager < Hash

  include Singleton

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
    clear
  end

  #Disconnects the bot with id id
  def disconnect(id)
    [id].quit
  end

  #Disconnects and removes bot with id id
  def kill(id)
    [id].delete.quit
  end

end