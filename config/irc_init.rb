#require 'cinch'
#
#$bot = Cinch::Bot.new do
#  configure do |c|
#    c.server = "127.0.0.1"
#    c.nick = 'miau_bot'
#    c.channels = ["#lobby"]
#  end
#
#  on :message, "hello" do |m|
#    m.reply "Hello, #{m.user.nick}"
#  end
#end
#
#$miau=Thread.new do
#  $bot.start
#end

#require 'cinch'
#require 'open-uri'
#require 'nokogiri'
#require 'cgi'
#
#$bot = Cinch::Bot.new do
#  configure do |c|
#    c.server = "127.0.0.1"
#    c.nick = 'miau_bot'
#    c.channels = ["#lobby"]
#  end
#
#  helpers do
#    # Extremely basic method, grabs the first result returned by Google
#    # or "No results found" otherwise
#    def google(query)
#      url = "http://www.google.com/search?q=#{CGI.escape(query)}"
#      res = Nokogiri::HTML(open(url)).at("h3.r")
#
#      title = res.text
#      link = res.at('a')[:href]
#      desc = res.at("./following::div").children.first.text
#    rescue
#      "No results found"
#    else
#      CGI.unescape_html "#{title} - #{desc} (#{link})"
#    end
#  end
#
#
#  on :message, /^!google (.+)/ do |m, query|
#    m.reply google(query)
#  end
#end
#
#$miau=Thread.new do
#  $bot.start
#end

#require 'cinch'
#
#class Messenger
#  include Cinch::Plugin
#
#  match /msg (.+?) (.+)/
#
#  def execute(m, receiver, message)
#    puts m
#    puts receiver
#    puts message
#    User(receiver).send(message)
#  end
#end
#
#
#n=5
#$bots=[]
#n.times do |i|
#  bot = Cinch::Bot.new do
#    configure do |c|
#      c.server = "127.0.0.1"
#      c.nick = "miau_#{i}"
#      c.channels = ["#lobby"]
#      c.plugins.plugins = [Messenger]
#    end
#  end
#  $bots << bot
#end
#
#
#$bots.each do |bot|
#  Thread.new do
#    bot.start
#    puts "#{bot.nick} started!"
#  end
#end
