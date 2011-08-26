module FayeSender

  # @param data [String] the exact string to be sent as-is
  # @param channel [String] the faye channel to send the data to
  # @return [Net::HTTP] for managing the http response from server when sending a message
  def send_via_faye(channel, data)
    message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(FAYE_SERVER_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

end