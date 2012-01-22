class RemoteIRCGateWay
  include Singleton
  attr_accessor :gateway_uri

  def initialize
    @gateway_uri = URI.parse(GATEWAY_SERVER_URL)
  end

  def create_vlan(vlan)
    id = vlan.id
    send_to_remote :create_vlan, :vlan_id => id
  end

  def remove_vlan(vlan)
    send_to_remote :create_vlan, :vlan => 1
  end

  def status
    send_to_remote.class
  end

  def send_to_remote(gateway_action = :status, the_params = {})
    params_to_send = {:gateway_action => gateway_action}.merge the_params
    Net::HTTP.post_form(@gateway_uri, params_to_send)
  end

  def send_irc(channel, message)
    send_to_remote :send_irc, :channel => channel, :message => message
  end

end
