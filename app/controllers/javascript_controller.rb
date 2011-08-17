class JavascriptController < ApplicationController

  #before_filter :authenticate_user!
  respond_to :js

  def faye_init

    @channels = []

    #each user its channel and a practice channel for regular chat
    if current_user
      @channels << current_user.username
    else #not signed in
      @channels << FAYE_DEFAULT_CHANNEL
    end

    @channels.collect! do |channel|
      "#{FAYE_CHANNEL_PREFIX}#{channel}"
    end
    logger.debug "###########################  channels are #{@channels}"

  end
end