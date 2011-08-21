#Requires
require "net/http"
require "json"

#Configure channel and message here
mensaje = '> Manualmente enviado por FAYE'
canal = 'admin'
#end of config xD

mensaje_real = "$('#irc_area').append(\"#{mensaje}\");"


# Procedure stuff
FAYE_TOKEN = 'miauhash'
FAYE_CHANNEL_PREFIX = '/messagebox/'
FAYE_DEFAULT_CHANNEL = 'lobby'
FAYE_SERVER_PORT = 9292
FAYE_MOUNT_POINT = '/faye'
FAYE_SERVER_URL = "http://localhost:#{FAYE_SERVER_PORT}#{FAYE_MOUNT_POINT}"
channel = "#{FAYE_CHANNEL_PREFIX}#{canal}"
message = {:channel => channel, :data => mensaje_real, :ext => {:auth_token => FAYE_TOKEN}}
#end

#Init
puts 'Initiating..'
puts "Posting to #{FAYE_SERVER_URL}"
puts " in channel #{channel}"
puts " with message #{mensaje}"
puts " with real message #{mensaje_real}"
puts "  message.to_json #{mensaje_real.to_json}"

uri = URI.parse(FAYE_SERVER_URL)
response = Net::HTTP.post_form(uri, :message => message.to_json)
puts "Server responded with> #{response}"

#END xD
