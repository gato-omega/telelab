class PracticaController < ApplicationController

  before_filter :load_bot, :only => ['message']

  def index
  end

  def message

    # Get the message and channel
    @message = params[:message]
    @channel = params[:channel]
    
    # Set default channel if non-existant
    if not @channel
      @channel = @bot_manager.config[:client][:default_channels].first
    end

    # Get the bot to send the message over the specified irc channel
    #Use error control in production mode only, uncomment the begin, rescue, end lines
    #begin
      @bot.action(@channel, @message)
      respond_to :js
    #rescue
      # Put some error message if something goes wrong
      flash[:notice] = 'Could not send message, irc bot error'
    #end
    # Notify or something?

  end

  def load_bot
    @bot_manager=GBotManager.instance
    @bot=@bot_manager.load_bot_for current_user
  end


#  def ASI_NO_SELLAAMmessage
#
#    #Get the message and channel
#    @message = params[:message]
#    @channel = params[:channel]
#
#    if @channel.nil?
#      @channel = FAYE_DEFAULT_CHANNEL
#      logger.debug "###########################  NIL channel is #{@channel}"
#    end
#
#    @channel = "#{FAYE_CHANNEL_PREFIX}#{@channel}"
#
##    if current_user
##      @faye_user_channel = current_user.username
##      @faye_practice_channel = 'lobby'
##    else
##      @faye_user_channel = "lobby"
##      @faye_practice_channel = 'lobby'
##    end
#
##renders message.js.erb
#
#    logger.debug "###########################  channel is #{@channel}"
#    logger.debug "###########################  message is #{@message}"
#
#    respond_to :js
#
#  end


end