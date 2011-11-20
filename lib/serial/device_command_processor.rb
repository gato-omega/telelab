require 'bayeux/custom_faye_sender'

class DeviceCommandProcessor

  attr_accessor :faye_messages_controller
  attr_accessor :vlan_output_buffer
  attr_accessor :vlan_input_buffer
  attr_accessor :irc_gateway
  
  include CustomFayeSender

  def initialize(irc_gateway)
    initialize_faye_processor
    @irc_gateway = irc_gateway
    @vlan_output_buffer=[]
    @vlan_input_buffer=[]
  end

  # Generates the serial output commands to create a vlan, based on a Vlan model object
  def serial_create_vlan(vlan)

    pr_id = vlan.practica.id
    p = vlan.puerto
    q = vlan.endpoint
    n = vlan.numero

    px = p.endpoint
    qx = q.endpoint

    pxname = px.nombre
    qxname = qx.nombre

    commands = [

        "#ENTER",
        "enable",
        "configure terminal",
        "interface #{pxname}",
        "switch mode access vlan #{n}",
        "swtich mode access",
        "no shutdown",
        "exit",
        "interface #{qxname}",
        "switch mode access vlan #{n}",
        "swtich mode access",
        "no shutdown",
        "exit",
        "exit",
        "exit"
    ]

    commands

  end

  # This method processes the incoming message from irc
  def process_irc_message(rcvd_channel, rcvd_user, rcvd_message)

    puts "############## DeviceCommandProcessor PROCESSING A >>> channel: #{rcvd_channel}, user: #{rcvd_user}, message: #{rcvd_message} ####"

    if rcvd_channel.eql? vlan_channel
      process_vlan_output rcvd_message
    elsif device_channels.include? rcvd_channel

      processed_message_output = ''

      the_channel = (rcvd_channel.split '#').last
      msg_type = (the_channel.split '_').first
      item_id = (the_channel.split '_').last

      puts "############## DeviceCommandProcessor PROCESSING B >>> channel: #{the_channel}, msg_type: #{msg_type}, item_id: #{item_id} ####"
      if msg_type.eql? 'device'
        # UNCOMMENT
        #processed_message_output=@faye_messages_controller.generate_terminal_output item_id, rcvd_message
        processed_message_output=FayeMessagesController.new.generate_terminal_output item_id, rcvd_message
      end

      puts "Processed message output > #{processed_message_output}"


      # Send it using the CustomFayeSender module

      # rcvd_channel is in the form #<resource>_<id>
      # faye_channel is in the form <resource>_<id>
      faye_channel = "#{FAYE_CHANNEL_PREFIX}#{the_channel}"

      send_via_faye faye_channel, processed_message_output
    else
      raise "Unknown IRC channel #{rcvd_channel}"
    end

  end

  def process_vlan_output output
    puts "ASDADASD"
  end

  def create_vlan(vlan)
    commands = serial_create_vlan vlan
    commands.each do |command|
      send_irc vlan_channel, command
      #puts "SENDING #{canal}, #{command}"
    end
  end

  def send_irc(channel, message)
    @irc_gateway.send_irc channel, message
  end

  def vlan_switch(force_reload=false)
    get_vlan_switch force_reload
  end

  private
  def initialize_faye_processor
    @faye_messages_controller = FayeMessagesController.new
  end

  # get the irc/normalized vlan channel
  def vlan_channel(options = {:irc => true})
    force_reload = false
    if options[:force_reload]
      force_reload = true
    end
    get_vlan_switch force_reload

    if options[:irc]
      "#device_#{@vlan_switch.id}"
    else
      "device_#{@vlan_switch.id}"
    end
  end

  def get_vlan_switch(force_reload=false)
    @vlan_switch = Dispositivo.where(:tipo >> 'vlan').first if (!@vlan_switch || force_reload)
    raise 'NO VLAN SWITCH TO USE!' unless @vlan_switch
  end

  def device_channels
    @irc_gateway.device_channels
  end

end