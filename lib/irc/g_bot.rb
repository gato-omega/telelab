require 'bayeux/custom_faye_sender'

class GBot < Cinch::Bot

  #include CustomFayeSender

  #attr_accessor :device_channels

  #def initialize_message_processor
  #  @message_processor = FayeMessagesController.new
  #end

  #def initialize_device_channels
  #  @device_channels = []
  #  Dispositivo.where(:estado => 'ok', :tipo => 'user').each do |dispositivo|
  #    @device_channels << "#device_#{dispositivo.id}"
  #  end
  #end

  def get_channel(channel)
    self.Channel channel
  end

  def get_user(user)
    self.User user
  end

end
