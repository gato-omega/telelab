#Requires
require "net/http"
require "json"

#Configure channel and message here
#mensaje = '> Manualmente enviado por FAYE'
canal = 'admin'
#end of config xD

#mensaje_real = "$('#irc_area').append(\"#{mensaje}\");"


# Procedure stuff
FAYE_TOKEN = 'miauhash'
FAYE_CHANNEL_PREFIX = '/messagebox/'
FAYE_DEFAULT_CHANNEL = 'lobby'
FAYE_SERVER_PORT = 9292
FAYE_MOUNT_POINT = '/faye'
FAYE_SERVER_URL = "http://localhost:#{FAYE_SERVER_PORT}#{FAYE_MOUNT_POINT}"
uri = URI.parse(FAYE_SERVER_URL)

###################33 OVERRIDE!!!!!

canal = FAYE_DEFAULT_CHANNEL
canal = 'device_1' ################3 OVERRIDE
channel = "#{FAYE_CHANNEL_PREFIX}#{canal}"
#end

#Init
puts 'Initiating..'
puts "Posting to #{FAYE_SERVER_URL}"
puts " in channel #{channel}"

mensaje = ''
while mensaje != "exit\n"
  mensaje = $stdin.gets
  message = {:channel => channel, :data => {:message => mensaje, :what => 'lol'}, :ext => {:auth_token => FAYE_TOKEN}}
  response = Net::HTTP.post_form(uri, :message => message.to_json)
  puts "Server responded with> #{response}"
end

puts 'Done'


#END xD
