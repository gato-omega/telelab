require 'irc/g_bot'
require 'serial/device_command_processor'

# The middleware gateway for IRC-BAYEUX (irc-faye)
# Has an irc transceiver and a faye sender
class IRCGateway

  include Singleton

  attr_accessor :zbot
  attr_accessor :config
  attr_accessor :bot_thread
  attr_accessor :message_processor
  attr_accessor :device_channels


  # Creates zbot, necessary to connect and do everything, IRCGateway...just the wrapper
  # Also initializes message processor and irc config portion from APP_CONFIG
  def initialize

    # Objects noted with the 'the_' prefix are used to be passed without risking
    # execution context name collisions

    # Put itself to be referenced by the internal irc bot #THE
    #the_faye_sender = self

    # Load IRC config part from APP_CONFIG #THE
    load_irc_config
    the_irc_config = @config

    #Load device_channels #THE
    the_device_channels = get_device_channels(true)

    # Initialize the message processor instance # THE
    the_message_processor = initialize_message_processor
    the_irc_gateway = self


    # Create the ZBOT, instance of GBot...lol
    @zbot = GBot.new do

      configure do |c|
        c.server = the_irc_config[:server][:ip]#'127.0.0.1'#
        c.nick = "#{the_irc_config[:client][:nick_prefix]}#{the_irc_config[:client][:nick]}"
        c.channels = the_irc_config[:client][:default_channels] + the_device_channels
      end

      #if the_irc_config[:client][:logger].eql? 'null'
      #
      #end

      #self.logger = Cinch::Logger::NullLogger.new($stderr)

      #Listen and do...
      on :message do |m|
        # self === Callback.new

        # Retrieve important params
        rcvd_message = m.message # "the message" the actual message
        rcvd_channel = m.channel.name # "#lobby" the channel it was sent on
        rcvd_user = m.user.nick # "charles" who sent it

        # Process it and get the required data to send

        # ELIMINATE
        the_message_processor=DeviceCommandProcessor.new(the_irc_gateway)

        the_message_processor.process_irc_message rcvd_channel, rcvd_user, rcvd_message

      end
    end

    # Finally...start da bot
    start
  end

  def create_vlan(vlan)
    # UNCOMMENT
    #@message_processor.create_vlan(vlan)
    DeviceCommandProcessor.new(self).create_vlan(vlan)
  end

  # Send a IRC message to a channel
  def send_irc(channel, message)
    real_channel = @zbot.get_channel(channel)
    if real_channel
      real_channel.send(message)
    else
      puts "############## CHANNEL #{channel} NOT FOUND !"
    end
  end

  def stop
    @bot_thread.terminate
  end

  def restart
    stop
    start
  end

  def start
    @bot_thread = Thread.new do
      @zbot.start
    end
  end

  private
  #Loads irc config in @config
  def load_irc_config(force_reload = false)
    if not @config and not force_reload
      @config=APP_CONFIG[:irc]
      # Append # sign to the beggining for free-channels
      @config[:client][:default_channels].collect! {|channel| "##{channel}"}
    end
  end

  def initialize_message_processor
    @message_processor = DeviceCommandProcessor.new(self)
  end

  def get_device_channels(force_reload=false)

    #if @device_channels && !force_reload
    #  @device_channels
    #else
    @device_channels = []

    Dispositivo.where(:estado >> 'ok').each do |dispositivo|
      @device_channels << "#device_#{dispositivo.id}"
    end

    #Safeguard
    if @device_channels.empty?
      Dispositivo.all.each do |dispositivo|
        @device_channels << "#device_#{dispositivo.id}"
      end
    end

    @device_channels

    #end

  end

end