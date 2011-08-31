#Requires
require 'faye'
require 'eventmachine'

# The usual defines
FAYE_TOKEN = 'miauhash'
FAYE_CHANNEL_PREFIX = '/messagebox/'
FAYE_DEFAULT_CHANNEL = 'lobby'
FAYE_SERVER_PORT = 9292
FAYE_MOUNT_POINT = '/faye'
FAYE_SERVER_URL = "http://localhost:#{FAYE_SERVER_PORT}#{FAYE_MOUNT_POINT}"

canal = FAYE_DEFAULT_CHANNEL
canal_all = "#{FAYE_CHANNEL_PREFIX}#{FAYE_DEFAULT_CHANNEL}"

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
end
listen_thread.exit
puts 'Done!'
