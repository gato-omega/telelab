class PracticaController < ApplicationController

  #before_filter :load_bot, :only => [:ircchat]

  def index
  end

  def message

    #Get the message and channel
    @message = params[:message]
    @channel = params[:channel]

    bot_manager=GBotManager.instance
    @bot=bot_manager.load_bot_for current_user


    if @channel.nil?
      @channel = bot_manager.config[:client][:default_channels].first
      logger.debug "###########################  NOW channel is #{@channel}"
    end

    logger.debug "###########################  channel is #{@channel}"
    logger.debug "###########################  message is #{@message}"

    @bot.action(@channel,@message)

    respond_to :js

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