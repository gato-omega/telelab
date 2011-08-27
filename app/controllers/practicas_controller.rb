class PracticasController < ApplicationController
  # GET /practicas
  # GET /practicas.xml
  def index
    @practicas = Practica.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @practicas }
    end
  end

    # GET /practicas/1
    # GET /practicas/1.xml
  def show
    @practica = Practica.find(params[:id])
    @dispositivos = @practica.dispositivos
    @allowedusers = @practica.users

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @practica }
    end
  end

    # GET /practicas/new
    # GET /practicas/new.xml
  def new
    @practica = Practica.new
    @dispositivos = Dispositivo.all
    @dispositivosreservados = @practica.dispositivos
    @allowed_users = []

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @practica }
    end
  end

    # GET /practicas/1/edit
  def edit
    @practica = Practica.find(params[:id])
    @dispositivos = Dispositivo.all
    @dispositivosreservados = @practica.dispositivos
    @allowed_users = @practica.users
  end

    # POST /practicas
    # POST /practicas.xml
  def create
    @practica = Practica.new(params[:practica])

    respond_to do |format|
      if @practica.save
        format.html { redirect_to(@practica, :notice => 'Practica was successfully created.') }
        format.xml { render :xml => @practica, :status => :created, :location => @practica }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @practica.errors, :status => :unprocessable_entity }
      end
    end
  end

    # PUT /practicas/1
    # PUT /practicas/1.xml
  def update
    params[:practica][:dispositivo_ids] ||= []
    @practica = Practica.find(params[:id])

    respond_to do |format|
      if @practica.update_attributes(params[:practica])
        format.html { redirect_to(@practica, :notice => 'Practica was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @practica.errors, :status => :unprocessable_entity }
      end
    end
  end

    # DELETE /practicas/1
    # DELETE /practicas/1.xml
  def destroy
    @practica = Practica.find(params[:id])
    @practica.destroy

    respond_to do |format|
      format.html { redirect_to(practicas_url) }
      format.xml { head :ok }
    end
  end

    ##################### add from reservas_controller old ########################################

  def json_users
    @all_users = User.where("username like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json { render :json => @all_users.collect { |user| {:id => user.id, :name => user.username} } }
    end
  end

    ############### add from practicas_controller old ############################

  #before_filter :load_bot, :only => [:ircchat]

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

    @bot.action(@channel, @message)

    respond_to :js

  end


  #def ASI_NO_SELLAAMmessage
  #
  #  #Get the message and channel
  #  @message = params[:message]
  #  @channel = params[:channel]
  #
  #  if @channel.nil?
  #    @channel = FAYE_DEFAULT_CHANNEL
  #    logger.debug "###########################  NIL channel is #{@channel}"
  #  end
  #
  #  @channel = "#{FAYE_CHANNEL_PREFIX}#{@channel}"
  #
  #  if current_user
  #    @faye_user_channel = current_user.username
  #    @faye_practice_channel = 'lobby'
  #  else
  #    @faye_user_channel = "lobby"
  #    @faye_practice_channel = 'lobby'
  #  end
  #
  #  renders message.js.erb
  #
  #  logger.debug "###########################  channel is #{@channel}"
  #  logger.debug "###########################  message is #{@message}"
  #
  #  respond_to :js
  #
  #end

end