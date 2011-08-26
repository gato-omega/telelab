module JavascriptHelper
  # Faye client initialization and perform itearation over the channels provided
  # block gets captured so that
  def subscribe_faye(client_name, channels, &block)
    js_out="var #{client_name} = new Faye.Client('#{FAYE_SERVER_URL}');"
    block_js = ''
    block_js = capture(&block) if block_given?
    channels.each do |channel|
      js_out << "#{client_name}.subscribe('#{channel}', function(data){ #{block_js} });"
    end
  end
end
