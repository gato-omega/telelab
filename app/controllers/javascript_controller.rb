class JavascriptController < ApplicationController

  #before_filter :authenticate_user!
  respond_to :js

  # Called when need faye client to initialize on the browser
  # with specific channel subscriptions for a particular user
  def faye_init

    # The @channels variable to pass how many
    @channels = []

    #each user has its channel and a practice channel for regular chat
    if current_user
      @channels << current_user.username
    else #not signed in
      @channels << FAYE_DEFAULT_CHANNEL
    end
    
    #Append prefix
    @channels.collect! do |channel|
      "#{FAYE_CHANNEL_PREFIX}#{channel}"
    end
  end
end