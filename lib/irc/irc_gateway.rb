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
  attr_accessor :faye_client


  # Creates zbot, necessary to connect and do everything, IRCGateway...just the wrapper
  # Also initializes message processor and irc config portion from APP_CONFIG
  def initialize

    #load server-side faye client
    @faye_client = Faye::Client.new(FAYE_SERVER_URL)

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
        c.server = the_irc_config[:client][:ip] #'127.0.0.1'#
        c.nick = "#{the_irc_config[:client][:nick_prefix]}#{the_irc_config[:client][:nick]}"
        c.channels = the_irc_config[:client][:default_channels].map {|channel| (channel.start_with? "#") ? channel : "##{channel}"} + the_device_channels

        # Server conf queue

        c.server_queue_size = 50
        c.messages_per_second = 50

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
        #the_message_processor=DeviceCommandProcessor.new(the_irc_gateway)

        # Prevent processing of other telelab zbot messages
        unless rcvd_user.starts_with? "#{APP_CONFIG[:irc][:client][:nick_prefix]}#{APP_CONFIG[:irc][:client][:nick]}"
          the_message_processor.process_irc_message rcvd_channel, rcvd_user, rcvd_message
        end

      end
    end

    # Finally...start da bot
    start
  end

  # Reset all practica resources
  def reset_practica(practica)
    reset_devices_for practica
    remove_vlans_for practica
  end

  # Remove vlan conections for a practica
  def remove_vlans_for(practica)
    vlans = practica.vlans
    DeviceCommandProcessor.new(self).remove_vlans vlans
  end

  # Reset devices for a practica
  def reset_devices_for(practica)
    dispositivos = practica.dispositivos
    DeviceCommandProcessor.new(self).reset_devices dispositivos
  end

  # Create a vlan using the logical vlan model passed as argument
  def create_vlan(vlan)
    # UNCOMMENT
    #@message_processor.create_vlan(vlan)
    DeviceCommandProcessor.new(self).create_vlan(vlan)
  end

  # Remove an existing vlan using the logical vlan model passed as argument
  def remove_vlan(vlan)
    DeviceCommandProcessor.new(self).remove_vlan(vlan)
  end

  # Reset a single device directly
  def reset_device(device)
    DeviceCommandProcessor.new(self).reset_device(device)
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
      @config = APP_CONFIG[:irc]
      # Append # sign to the beggining for free-channels
      @config[:client][:default_channels].collect! {|channel| "##{channel}"}
    end
  end

  def initialize_message_processor
    @message_processor = DeviceCommandProcessor.new(self)
  end

  # Initializes the devices
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
