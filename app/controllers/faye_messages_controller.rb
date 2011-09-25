# FayeMessagesController is an AbstractController that
# allows usage of rendering javascript templates to
# send Faye Messages eval javascript to browsers
# Define your faye message in the corresponding view!
class FayeMessagesController < AbstractController::Base
      
  include AbstractController::Rendering
  #include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  #include ActionController::UrlWriter

  # Uncomment if you want to use helpers defined in ApplicationHelper in your views
  # helper ApplicationHelper

  # Make sure your controller can find views
  self.view_paths = "app/views"

  # You can define custom helper methods to be used in views here
  # helper_method :current_admin
  # def current_admin; nil; end

  def whatever(lool)
    @lol = "rvalue> (#{lool})"
    #The following line is necessary
    render template: "faye_messages/whatever"
    # or, for partials:
    # render partial: "hello_world/show"
  end

  def normal_method_is(something)
    whatever("your param here> #{something}")
  end

  # This method processes the incoming message from irc and
  # returns the data as-is to be delivered to a FayeSender

  def process_irc_message(rcvd_channel, rcvd_user, rcvd_message)
    # do normal_method_is
    processed_message_output = ''
    puts "############## PROCESSING A >>> channel: #{rcvd_channel}, user: #{rcvd_user}, message: #{rcvd_message} ####"

    rcvd_channel = (rcvd_channel.split '#').last
    msg_type = (rcvd_channel.split '_').first
    item_id = (rcvd_channel.split '_').last

    puts "############## PROCESSING B >>> channel: #{rcvd_channel}, msg_type: #{msg_type}, item_id: #{item_id} ####"


    if msg_type == 'device'
      processed_message_output=generate_terminal_output item_id, rcvd_message
    end

    if msg_type == 'practica'
      processed_message_output = generate_chat_output item_id, rcvd_message
    end
    
    puts "Processed message output > #{processed_message_output}"
    processed_message_output
  end

  def generate_terminal_output(device_id, message)
    @device_id = device_id
    @mensaje = message
    render template: "faye_messages/terminal"
  end

  def generate_terminal_user_output(mensaje)
    @mensaje = mensaje
    @terminal_id = (@mensaje[:channel].split '_').last
    render template: "faye_messages/terminal_user"
  end

  def generate_chat_output(practica_id, message)
    @practica_id = practica_id
    @mensaje = message
    render template: "faye_messages/chat"
  end
end
