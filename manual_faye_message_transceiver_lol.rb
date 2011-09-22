#Requires
require 'faye'
require 'eventmachine'
require "net/http"
require "json"
require "colorize"


# The usual defines
FAYE_TOKEN = 'miauhash'
FAYE_CHANNEL_PREFIX = '/messagebox/'
FAYE_DEFAULT_CHANNEL = 'lobby'
FAYE_SERVER_PORT = 9292
FAYE_MOUNT_POINT = '/faye'
FAYE_SERVER_URL = "http://localhost:#{FAYE_SERVER_PORT}#{FAYE_MOUNT_POINT}"
uri = URI.parse(FAYE_SERVER_URL)
canales = []
#canales = ['device_1', 'device_2', 'device_3']
10.times do |i|
  canales << "device_#{i+1}"
end

#Initialization
state = 0

puts " --------------------------------- ".black.on_yellow
puts " - FAYE TRANSCEIVER by Gato v1.0 - ".black.on_yellow
puts " --------------------------------- ".black.on_yellow
puts ''


puts "Initializing Faye Client ..."
begin
  client = Faye::Client.new(FAYE_SERVER_URL)
  puts "Faye Client started".light_green
rescue
  puts "Failed to connect to Faye server".light_red
  state += 1
end

listen_thread = nil
if state == 1

else
  puts "Initializing EventMachine..."
  #DO STUFF

  # Put prefix to all of them
  canales.collect! do |canal|
    "#{FAYE_CHANNEL_PREFIX}#{canal}"
  end

  #EventMachine init
  begin

    listen_thread = Thread.new do
      EM.run do
        canales.each do |canal|
          puts "Listening on '#{canal}' ...".yellow
          client.subscribe("#{canal}") do |message|
            puts "[#{canal.light_yellow}]"+" >> "+"#{message}".light_cyan
          end
        end
      end
    end

    puts "\nEM started!".green

  rescue
    puts "Event Machine dead...".red
  end

end

puts 'Ready... press enter'.blue
$stdin.gets

# stops
line =''
while !line.eql? "exit"
  print '>> '.blue
  line = $stdin.gets

  line = line[0,line.size-1]

  if !line.empty?
    canales.each do |canal|
      message = {:channel => canal, :data => line, :ext => {:auth_token => FAYE_TOKEN}}
      response = Net::HTTP.post_form(uri, :message => message.to_json)
    end
  end
end

listen_thread.exit
puts 'Done!'.light_green
