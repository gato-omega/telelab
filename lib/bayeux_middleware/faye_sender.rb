module FayeSender

  # @param data [String] the exact string to be sent as-is
  # @param channel [String] the faye channel to send the data to
  # @return [Net::HTTP] for managing the http response from server when sending a message
  def send_via_faye(channel, data)
    message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(FAYE_SERVER_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  #def send_via_faye_with_block(channel, &block)
  #  message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
  #  uri = URI.parse(FAYE_SERVER_URL)
  #  Net::HTTP.post_form(uri, :message => message.to_json)
  #end
  #
  #def send_string_via_faye(channel, string)
  #
  #end
  #
  #def send_javascript_via_faye(channel, javascript_text)
  #
  #end
  #
  #def send_block_captured_via_faye(channel, &block)
  #  message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
  #  uri = URI.parse(FAYE_SERVER_URL)
  #  Net::HTTP.post_form(uri, :message => message.to_json)
  #end
  #
  #def send_block_eval_via_faye(channel, &block)
  #
  #end


  #def send_via_faye(channel, data)
  #
  #  puts "IN send_via_faye"
  #  puts "############################## channel #{channel}"
  #  puts "############################## mensaje #{data}"
  #  message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN}}
  #  puts "############################## message #{message}"
  #  uri = URI.parse(FAYE_SERVER_URL)
  #  puts "############################## uri #{uri}"
  #  puts "############################## message.to_json #{message.to_json}"
  #  Net::HTTP.post_form(uri, :message => message.to_json)
  #end

end