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
    @lol = "in whatever> (#{lool})"

    #The following line is necessary
    render template: "faye_messages/whatever"
    # or, for partials:
    # render partial: "hello_world/show"
  end

  def normal_method_is(something)
    whatever("> #{something}")
  end

  # This method processes the incoming message from irc and
  # returns the data as-is to be delivered to a FayeSender

  def process_message(rcvd_channel, rcvd_user, rcvd_message)
    # do normal_method_is
    puts "############## YEAH>>> channel: #{rcvd_channel}, user: #{rcvd_user}, message: #{rcvd_message} ####"
    normal_method_is("channel: #{rcvd_channel}, user: #{rcvd_user}, message #{rcvd_message} ####")
  end
end
