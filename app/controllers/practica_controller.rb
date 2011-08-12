class PracticaController < ApplicationController

  before_filter :load_bot, :only => [:ircchat]

  def index
  end

  def ircchat
    @message = params[:message]

    #@current_user_lol =  current_user

    logger.debug "#################################### session.awesome_inspect #{session.awesome_inspect}"

    if @message.eql? 'killbots'
      killbots
      @response = "killed bots"
    else
      lol= ""
      GbotManager.instance.each do |k, v|
        lol+= " | session #{k}, bot #{v.nick}"
      end

      @response = lol
    end

    logger.debug "#################################### message #{@message}"
    logger.debug "#################################### response #{@response}"

    respond_to do |format|
      format.js
      format.xml { render :xml => @message }
    end
  end

  private
  def load_bot

    @current_user_lol = current_user
    @current_controller_instance_lol = self
    @session_id_lol =  session[:session_id]
    bot_manager = GbotManager.instance

    if bot_manager[session[:session_id]].nil?

      @bot = GBot.new do

        configure do |c|
          c.server = "127.0.0.1"
          c.nick = "bot_miau"
          c.channels = ["#lobby"]
        end

        add_listener @current_controller_instance_lol

        on :message do |m|
          listener.execute m
        end

      end

      Thread.new do
        @bot.start
      end

      bot_manager[session[:session_id]] = @bot
      
    else
      @bot = bot_manager[session[:session_id]]
      if !@bot.connected?
        Thread.new do
          @bot.start
        end
      end
    end
  end

  def killbots
    bot_manager = GbotManager.instance
    bot_manager.each do |session_key, bot|
      logger.debug "killing bot #{bot.nick} with id #"
      bot.quit
    end
  end

  def execute(m)
    logger.debug "m= #{m}"
    logger.debug "m.class= #{m.class}"
    #@response = m
  end

end
