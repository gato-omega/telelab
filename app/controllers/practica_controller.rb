class PracticaController < ApplicationController

  #before_filter :load_bot, :only => [:ircchat]

  def index
  end

  def message

    #get the message
    @message = params[:message]
    @channel = params[:channel]

    if @channel.nil?
      @channel = FAYE_DEFAULT_CHANNEL
      logger.debug "###########################  NIL channel is #{@channel}"
    end
    
    @channel = "#{FAYE_CHANNEL_PREFIX}#{@channel}"

#    if current_user
#      @faye_user_channel = current_user.username
#      @faye_practice_channel = 'lobby'
#    else
#      @faye_user_channel = "lobby"
#      @faye_practice_channel = 'lobby'
#    end

    #renders message.js.erb

    logger.debug "###########################  channel is #{@channel}"
    logger.debug "###########################  message is #{@message}"

    respond_to :js
    
  end

end