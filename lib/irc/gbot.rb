require 'bayeux_middleware/custom_faye_sender'

class GBot < Cinch::Bot

  attr_accessor :associated_user
  include CustomFayeSender

  def connected?
    @connected
  end

  # This method's error handling is quite bad!!
  def start
    begin
      
      begin
        super
        @connected = true
      rescue
        @connected = false
      end

    rescue
      @connected = false
    end
  end

  def quit
    @connected = false
    super
  end

  def unbind_user
    @associated_user=nil
  end

end
