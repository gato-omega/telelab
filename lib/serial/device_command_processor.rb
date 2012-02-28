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

  def initialize_vlan_switch
    get_vlan_switch
    commands = [
        "#ENTER",
        "enable",
        "configure terminal",
        "interface vlan 1",
        "no ip address",
        "no ip route-cache",
        "shutdown",
        "exit",
        "exit",
        "exit"
    ]
    send_commands_to_channel vlan_channel, commands
  end

  def initialize_vlan_switch_vlans
    get_vlan_switch
    commands = serial_enable_conft_prompt
    send_commands_to_channel vlan_channel, commands
    
    @vlan_switch.puertos_utiles.each do |puerto|
      commands = serial_reset_port(puerto)
      send_commands_to_channel vlan_channel, commands
      puts "  Sleeping for 20 seconds to wait command proccessing...".light_yellow
      sleep 20
    end

    commands = serial_exit_conft_prompt
    send_commands_to_channel vlan_channel, commands
  end

  # Exits until prompt
  def serial_enable_prompt
    commands = [
        "exit",
        "exit",
        "exit",
        "exit",
        "#ENTER",
        "enable"
    ]
    #commands = %W(exit exit exit exit #ENTER enable)
    commands
  end

  def serial_enable_conft_prompt
    commands = [
        "#ENTER",
        "enable",
        "configure terminal"
    ]
    commands
  end

  def serial_exit_conft_prompt
    commands = [
        "exit",
        "exit"
    ]
    commands
  end

  # Generates the serial output commands to reset a device, based on the device instance passed
  def serial_reset_device
    commands = [
        "erase startup-config",
        "#ENTER",
        "reload"
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
        "switchport access vlan #{n}",
        "switchport mode access",
        "no shutdown",
        "exit",
        "interface #{qxname}",
        "switchport access vlan #{n}",
        "switchport mode access",
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
        "switchport access vlan #{px.numero+1}",
        "switchport mode access",
        "no shutdown",
        "exit",
        "interface #{qxname}",
        "switchport access vlan #{qx.numero+1}",
        "switchport mode access",
        "no shutdown",
        "exit",
        "exit",
        "exit"
    ]

    commands

  end

  # Reset all ports in individual vlans for a device
  #def serial_reset_device_ports(device)
  #
  #  puertos = device.puertos
  #
  #  # Assigns original vlan numbers to each port. e.g. vlan 2 for port 1, 5 for 4 etc..
  #
  #  commands = []
  #
  #  puertos.each do |puerto|
  #    commands += serial_reset_port(puerto)
  #  end
  #
  #  commands
  #
  #end

  # Reset all ports in individual vlans for a device
  def serial_reset_port(puerto)

    commands = []
    #commands << "#ENTER"
    #commands << "enable"
    #commands << "configure terminal"
    commands << "interface #{puerto.nombre}"
    commands << "switchport access vlan #{puerto.numero+1}"
    commands << "switchport mode access"
    commands << "no shutdown"
    commands << "exit"
    #commands << "exit"
    #commands << "exit"
    commands
  end

  def set_enable_prompt(device)
    commands = serial_enable_prompt
    channel = device.irc_channel
    send_commands_to_channel channel, commands
  end

  def send_reset_token(device, status)
    channel = device.irc_channel
    the_status = status ? "TRUE" : "FALSE"
    send_irc channel, "#RESET_#{the_status}_84652"
  end

  def reset_device(device)
    commands = serial_reset_device
    channel = device.irc_channel
    send_commands_to_channel channel, commands, 0.5
  end

  # This method processes the incoming message from irc
  def process_irc_message(rcvd_channel, rcvd_user, rcvd_message)

    puts "############## DeviceCommandProcessor PROCESSING A >>> channel: #{rcvd_channel}, user: #{rcvd_user}, message: #{rcvd_message} ####"

    if rcvd_channel.eql? vlan_channel
      process_vlan_output rcvd_message
    elsif device_channels.include? rcvd_channel

      the_channel = (rcvd_channel.split '#').last
      msg_type = (the_channel.split '_').first
      item_id = (the_channel.split '_').last

      puts "############## DeviceCommandProcessor PROCESSING B >>> channel: #{the_channel}, msg_type: #{msg_type}, item_id: #{item_id} ####"
      if msg_type.eql? 'device'
        # Get the device
        the_device = Dispositivo.find(item_id.to_i)
        case the_device.status # resetting, initiating, ready
          when 'resetting' # process reset commands
                           # compare to list of commands that must match, to send appropiate response
            the_response = reset_command_response_for(rcvd_message, the_device)# The key is the message received
                                                                               # and send the response
            send_irc rcvd_channel, the_response unless the_response.blank?

          when 'ready'

            # UNCOMMENT
            #processed_message_output=@faye_messages_controller.generate_terminal_output item_id, rcvd_message
            processed_message_output = FayeMessagesController.new.generate_terminal_output item_id, rcvd_message

            # Send it using the CustomFayeSender module

            # rcvd_channel is in the form #<resource>_<id>
            # faye_channel is in the form <resource>_<id>
            faye_channel = "#{FAYE_CHANNEL_PREFIX}#{the_channel}"

            send_via_faye faye_channel, processed_message_output
            open_practica = Practica.search({:estado_equals => 'abierta', :dispositivos_id_in => [the_device.id]}, :join_type => :inner).first
            device_response_to_message = Message.new(:content => rcvd_message, :practica => open_practica, :dispositivo => the_device)
            if device_response_to_message.save
              puts "Processed message output > #{processed_message_output}"
            else
              puts "Could not save the device response due to: #{device_response_to_message.errors.full_messages}"
            end
            puts "Processed message output > #{processed_message_output}"
          else
            puts "!! !! !! Error in message status > Status: #{the_device.status}, the_device.id = #{the_device.id}"
        end
      end
    else
      raise "Unknown IRC channel #{rcvd_channel}"
    end
  end

  def reset_command_response_for(message, device)
    # Sleep 500 ms
    sleep 0.5
    #Then do this...
    if message =~ /unknown/
      "exit"
    elsif message =~ /RETURN/
      "#ENTER"
    elsif message =~ /#/ && @last_message =~ /RETURN/
      reset_device device
      ""
    elsif message =~ /Save\?/
      "no"
    elsif message =~ /reload\?/
      send_reset_token dispositivo, true
      "#ENTER"
    elsif message =~ /autoinstall\?/
      "#ENTER"
    elsif message =~ /dialog\?/
      "no"
    end
    @last_message=message
  end

  # Whichever message gets to the vlan switch, process it here
  # output is received from the vlan switch, so <tt>output<tt> is input to this method
  def process_vlan_output(output)
    puts output
  end

  # Reset the dispositivos sending the appropiate commands to them
  def reset_devices(dispositivos)
    dispositivos.each do |dispositivo|
      set_enable_prompt dispositivo
      reset_device dispositivo
    end
  end

  # Removes the vlans sending the appropiate commands to them
  def remove_vlans(vlans)
    vlans.each do |vlan|
      remove_vlan vlan
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

  # Uses the IRCGateway to send, this is just a wrapper
  def send_irc(channel, message)
    @irc_gateway.send_irc channel, message
  end

  def vlan_switch(force_reload=false)
    get_vlan_switch force_reload
    @vlan_switch
  end

  # Given an array of commands (String), send them through the given channel
  def send_commands_to_channel(channel, commands, interval = nil)
    commands.each do |command|
      if interval
        sleep interval
      end
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
