#Requires
require 'faye'
require 'eventmachine'
require "net/http"
require "json"

# The usual defines
FAYE_TOKEN = 'miauhash'
FAYE_CHANNEL_PREFIX = '/messagebox/'
FAYE_DEFAULT_CHANNEL = 'lobby'
FAYE_SERVER_PORT = 9292
FAYE_MOUNT_POINT = '/faye'
FAYE_SERVER_URL = "http://localhost:#{FAYE_SERVER_PORT}#{FAYE_MOUNT_POINT}"
uri = URI.parse(FAYE_SERVER_URL)
canal = FAYE_DEFAULT_CHANNEL

canal =  'admin' ##OVERRIDE

canal_all = "#{FAYE_CHANNEL_PREFIX}#{canal}"


#Initialization
state = 0

puts "Initializing Faye Client ..."
begin
  client = Faye::Client.new(FAYE_SERVER_URL)
  puts "Faye Client started"
rescue
  puts "Failed to connect to Faye server"
  state += 1
end

listen_thread = nil
if state == 1
  
else
  puts "Initializing EventMachine..."
  #DO STUFF
  begin

    listen_thread = Thread.new do
      EM.run do
        puts "Listening on '#{canal_all}' ..."
        client.subscribe("#{canal_all}") do |message|
          puts "(#{canal})>>  #{message}"
        end
      end
    end

    puts "EM started!"

  rescue
    puts "Event Machine dead..."
  end

end

# stops
line =''
while !line.eql? "exit\n"
  line = $stdin.gets
  message = {:channel => canal_all, :data => line, :ext => {:auth_token => FAYE_TOKEN}}
  response = Net::HTTP.post_form(uri, :message => message.to_json)
  puts "Server responded with> #{response}"
  print '>>'
end

listen_thread.exit
puts 'Done!'
