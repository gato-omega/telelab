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
    begin
      super
    rescue
      @connected = false
    end
  end

  def quit
    @connected = false
    super
  end

end
