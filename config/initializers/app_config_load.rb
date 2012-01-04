require 'open-uri'
require 'yaml'
raw_config = File.read("config/app_config.yml")
#raw_config = File.expand_path("../config//app_config.yml", __FILE__).read #DOES NOT WORK

unless defined? GatoDomainConfigurator
  class GatoDomainConfigurator
    include OpenURI

    def external_ip
      ip = '127.0.0.1'
      begin
        ip=OpenURI.open_uri("http://myip.dk") {|f|f.read.scan(/([0-9]{1,3}\.){3}[0-9]{1,3}/); $~.to_s}
      rescue
        puts "Seems like there is a problem adquiring external IP address, using localhost (127.0.0.1)"
      end
      ip
    end

    def local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
      UDPSocket.open do |s|
        s.connect google_ip, 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig # Return to original state
    end

    # A reference ip to do lookup
    def google_ip
      '74.125.47.99'
    end

  end
end

# If no symbolized keys defined
unless Hash.new.respond_to? :symbolize_keys!
  class Hash
    # File activesupport/lib/active_support/core_ext/hash/keys.rb, line 23
    def symbolize_keys!
      keys.each do |key|
        self[(key.to_sym rescue key) || key] = delete(key)
      end
      self
    end
  end
end

def recursive_symbolize_keys! hash
  hash.symbolize_keys!
  hash.values.select{|v| v.is_a? Hash}.each{|h| recursive_symbolize_keys!(h)}
end

configurator = GatoDomainConfigurator.new

local_ip = configurator.local_ip
external_ip = configurator.external_ip

if defined? Rails
  app_config = YAML.load(raw_config)[Rails.env]
else
  app_config = YAML.load(raw_config)['production']
end

recursive_symbolize_keys! app_config

# Domain IP address
if app_config[:domain].eql? 'local'
  app_config[:domain] = local_ip
elsif app_config[:domain].eql? 'external'
  app_config[:domain] = external_ip
end

# Faye server ip address
if app_config[:faye][:server][:auto].eql? 'local'
  app_config[:faye][:server][:url] = "http://#{local_ip}"
elsif app_config[:faye][:server][:auto].eql? 'external'
  app_config[:faye][:server][:url] = "http://#{external_ip}"
end

# IRC Server ip adress
if app_config[:irc][:server][:auto].eql? 'local'
  app_config[:irc][:server][:ip] = local_ip
elsif app_config[:irc][:server][:auto].eql? 'external'
  app_config[:irc][:server][:ip] = external_ip
end

APP_CONFIG = app_config

FAYE_TOKEN = APP_CONFIG[:faye][:server][:token]
FAYE_CHANNEL_PREFIX = APP_CONFIG[:faye][:server][:channel_prefix]
FAYE_DEFAULT_CHANNEL = APP_CONFIG[:faye][:server][:default_channel]
FAYE_SERVER_PORT = APP_CONFIG[:faye][:server][:port]
FAYE_MOUNT_POINT = APP_CONFIG[:faye][:server][:mount]
FAYE_SERVER_URL = "#{APP_CONFIG[:faye][:server][:url]}:#{FAYE_SERVER_PORT}#{FAYE_MOUNT_POINT}"
