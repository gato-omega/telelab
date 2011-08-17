require 'eventmachine'
class BayeuxIRCConnector
  attr_accessor :irc_client
  attr_accessor :faye_client

  def initialize
    #@faye_client = client = Faye::Client.new(FAYE_SERVER_URL)
  end

end