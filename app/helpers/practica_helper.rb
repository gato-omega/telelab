module PracticaHelper

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(FAYE_SERVER_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)

    logger.debug "###########################  message is #{message}"
    logger.debug "###########################  mesjson is #{message.to_json}"
    logger.debug "###########################  channel is #{channel}"
    logger.debug "###########################  capture is #{capture(&block)}"
    nil
  end

  def broadcaast(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

end
