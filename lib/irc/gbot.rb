class GBot < Cinch::Bot

  #include FayeSender
  include ActionView::Helpers::JavaScriptHelper

  attr_accessor :associated_user

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

  def unbind_user
    @associated_user=nil
  end
  
  def send_via_faye(channel, mensaje)

    puts "HIJUEPUTAAAAAA 6 estoy en ......... self        = #{self}"
          puts "HIJUEPUTAAAAAA 6 estoy en ......... self.to_s   = #{self.to_s}"
          puts "HIJUEPUTAAAAAA 6 estoy en ......... self.class  = #{self.class}"
    
    message = {:channel => channel, :data => mensaje, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(FAYE_SERVER_URL)
    puts Net::HTTP.post_form(uri, :message => message.to_json)
    nil
  end

end
