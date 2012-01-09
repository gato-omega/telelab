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

  # Generates the serial output commands to reset a device, based on the device instance passed
  def serial_reset_device(device)
    commands = [

        "#ENTER",
        "Aqui van los comandos pa resetear",
        "resetting: dispositivo #{device.id}",
        "exit"
    ]
    commands
  end

  # Generates the serial output commands to create a vlan, based on a Vlan model object
  def serial_create_vlan(vlan)

    p = vlan.puerto
    q = vlan.endpoint
    n = vlan.numero # Vlan number to be assigned

    px = p.endpoint # P In the vlan switch
    qx = q.endpoint # Q In the vlan switch

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

  # Generates the serial output commands to remove a vlan, based on a Vlan model object
  def serial_remove_vlan(vlan)

    p = vlan.puerto
    q = vlan.endpoint

    px = p.endpoint
    qx = q.endpoint

    pxname = px.nombre
    qxname = qx.nombre

    # Assigns original vlan numbers to each port. e.g. vlan 2 for port 1, 5 for 4 etc..

    commands = [

        "#ENTER",
        "enable",
        "configure terminal",
        "interface #{pxname}",
        "switch mode access vlan #{px.numero+1}",
        "swtich mode access",
        "no shutdown",
        "exit",
        "interface #{qxname}",
        "switch mode access vlan #{qx.numero+1}",
        "swtich mode access",
        "no shutdown",
        "exit",
        "exit",
        "exit"
    ]

    commands

  end

  def reset_device(device)
    commands = serial_reset_device device
    channel = device.irc_channel
    send_commands_to_channel channel, commands
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

  def process_vlan_output(output)
    ap output
  end

  def reset_devices(dispositivos)
    dispositivos.each do |dispositivo|
      Thread.new do
        reset_device dispositivo
      end
    end
  end

  def remove_vlans(vlans)
    vlans.each do |vlan|
      Thread.new do
        remove_vlan vlan
      end
    end
  end

  def create_vlan(vlan)
    commands = serial_create_vlan vlan
    channel = vlan_channel
    send_commands_to_channel channel, commands
  end

  def remove_vlan(vlan)
    commands = serial_remove_vlan vlan
    channel = vlan_channel
    send_commands_to_channel channel, commands
  end

  def send_irc(channel, message)
    @irc_gateway.send_irc channel, message
  end

  def vlan_switch(force_reload=false)
    get_vlan_switch force_reload
  end

  def send_commands_to_channel(channel, commands)
    commands.each do |command|
      send_irc channel, command
    end
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