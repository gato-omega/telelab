require 'bayeux/custom_faye_sender'
require 'irc/g_bot'
require 'serial/device_command_controller'

# The middleware gateway for IRC-BAYEUX (irc-faye)
# Has an irc transceiver and a faye sender
class IRCGateway

  include Singleton
  include CustomFayeSender
  include DeviceCommandController

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

    # Initialize the message processor instance # THE
    the_message_processor = initialize_message_processor

    # Put itself to be referenced by the internal irc bot #THE
    the_faye_sender = self

    # Load IRC config part from APP_CONFIG #THE
    load_irc_config
    the_irc_config = @config

    #Load device_channels #THE
    the_device_channels = initialize_device_channels

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

        # PLEASE ELIMINATE THIS!
        the_message_processor=FayeMessagesController.new

        mensaje_raw = the_message_processor.process_irc_message rcvd_channel, rcvd_user, rcvd_message

        # Send it using the CustomFayeSender module of the_faye_sender

        # Get this users faye channel to send to
        # rcvd_channel is in the form #<resource>_<id>
        # faye_channel is in the form <resource>_<id>
        faye_channel = "#{FAYE_CHANNEL_PREFIX}#{(rcvd_channel.split '#').last}"

        # ...and send via internal bot reference
        the_faye_sender.send_via_faye faye_channel, mensaje_raw
      end
    end

    # Finally...start da bot
    start
  end

  # Send a IRC message to a channel
  def send_irc(channel, message)
    real_channel = @zbot.get_channel(channel)
    if real_channel
      real_channel.action(message)
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

  def create_vlan(vlan)
    vlan_switch = Dispositivo.where(:tipo => 'vlan').first
    if vlan_switch
      canal = "#device_#{vlan_switch.id}"
      commands = serial_create_vlan vlan
      commands.each do |command|
        send_irc canal, command
        #puts "SENDING #{canal}, #{command}"
      end
    else
      raise 'NO VLAN SWITCH TO USE!'
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
    @message_processor = FayeMessagesController.new
  end

  def initialize_device_channels
    @device_channels = []
   
    Dispositivo.where(:estado >> 'ok') do |dispositivo|
      @device_channels << "#device_#{dispositivo.id}"
    end

    @device_channels
  end

end