require 'cinch'
class GBot < Cinch::Bot

  attr_accessor :listener

  def add_listener(listener)
    @listener = listener
  end

  def connected?
    @connected
  end

  def start
    @connected = true
    super
  end

  def quit
    @connected = false
    super
  end

end

class GbotManager < Hash
  include Singleton

  def start(bot)
    Thread.new do
      bot.start
    end
  end


  def start_all
    each do |session, bot|
      Thread.new do
        if !bot.connected?
          bot.start
        end
      end
    end
  end
  
end

class Messenger
  include Cinch::Plugin

  def execute(m, receiver, message)
    User(receiver).send(message)
  end
end
