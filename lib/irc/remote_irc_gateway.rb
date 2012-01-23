class RemoteIRCGateway
  include Singleton
  attr_accessor :gateway_uri

  def initialize
    @gateway_uri = URI.parse(GATEWAY_SERVER_URL)
  end

  def create_vlan(vlan)
    id = vlan.id
    send_to_remote :create_vlan, :id => id
  end

  def remove_vlan(puerto_id, endpoint_id, practica_id)
    send_to_remote :remove_vlan, :vlan => {:puerto_id => puerto_id,:endpoint_id => endpoint_id, :practica_id => practica_id}
  end

  def status
    send_to_remote.class
  end

  def send_irc(channel, message)
    send_to_remote :send_irc, :channel => channel, :message => message
  end

  def reset_practica(practica)
    send_to_remote :reset_practica, :id => practica.id
  end

  def send_to_remote(gateway_action = :status, the_params = {})
    params_to_send = {:gateway_action => gateway_action}.merge the_params
    Net::HTTP.post_form(@gateway_uri, params_to_send)
  end

end
