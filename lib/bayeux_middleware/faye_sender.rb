module FayeSender

  def send_via_faye(channel, mensaje)
    message = {:channel => channel, :data => mensaje, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(FAYE_SERVER_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
    nil
  end

  def send_via_faye_with_block(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(FAYE_SERVER_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
    nil
  end

end