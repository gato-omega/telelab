class PracticasController < ApplicationController

  respond_to :html, :only => [:index, :show, :new, :edit]
  before_filter :get_practice, :only => [:show, :edit, :lab, :make_practice]
  before_filter :initialize_faye_session_keys, :only => [:make_practice]

  include CustomFayeSender


  # USE INCLUDE!!!!!!!!!!!!!!!  Practica.find(1, :include => :users, :devices.......stuff like that, eager loading)

  def index
    @practicas = Practica.all
  end

  def show

  end

  def new
    @practica = Practica.new
    @dispositivos = Dispositivo.all
    @dispositivos_reservados = []
    @allowed_users = []
  end

  def edit
    @dispositivos = Dispositivo.all
  end

  def create
    @practica = Practica.new(params[:practica])

    respond_to do |format|
      if @practica.save
        format.html { redirect_to(@practica, :notice => 'Practica was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    params[:practica][:dispositivo_ids] ||= []
    @practica = Practica.find(params[:id])

    respond_to do |format|
      if @practica.update_attributes(params[:practica])
        format.html { redirect_to(@practica, :notice => 'Practica was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @practica.destroy

    respond_to do |format|
      format.html { redirect_to(practicas_url) }
    end
  end

  def make_practice
    puts "####################### WHAT DA FAQQQQQQQ class = #{session[:faye].class}"
    puts "####################### WHAT DA FAQQQQQQQ value = #{session[:faye]}"

    

  end

  def terminal

    @mensaje = {}
    @mensaje[:message] = params[:message][:content]

    # Filter non-permitted commands and log, whatever we want
    if not @mensaje[:message].empty?

      # Send through faye first to provide echo
      @mensaje[:channel] = params[:message][:channel]
      # Set echo to true if sending to himself via faye is required
      @mensaje[:echo] = false

      if current_user
        @mensaje[:user] = current_user.username
      else
        @mensaje[:user] = 'unregistered_user_miau'
      end

      the_irc_gateway = IRCGateway.instance

      #mensaje_raw = the_irc_gateway.message_processor.generate_terminal_user_output @mensaje
      mensaje_raw = FayeMessagesController.new.generate_terminal_user_output @mensaje


      send_via_faye "#{FAYE_CHANNEL_PREFIX}#{@mensaje[:channel]}", mensaje_raw


      # Send through IRCGateway...
      the_irc_gateway.zbot.action("##{@mensaje[:channel]}", @mensaje[:message])
    end

    render :nothing => true

  end

  def lab
    @faye_channels = @dispositivos_reservados.map do |dispositivo| "#{FAYE_CHANNEL_PREFIX}device_#{dispositivo.id}" end
    @faye_channels << "#{FAYE_CHANNEL_PREFIX}practica_#{@practica.id}"
    @faye_server_url = FAYE_SERVER_URL

    if current_user
      @username = current_user.username
    else
      @username = 'unregistered_user'
    end

    respond_to do |format|
      format.js
    end
  end

  def chat
    @mensaje = {}
    @mensaje[:message] = params[:message][:content]

    # Filter non-permitted commands and log, whatever we want
    if not @mensaje[:message].empty?

      # Send through faye first to provide echo
      @mensaje[:channel] = params[:message][:channel]
      # Set echo to true if sending to himself via faye is required
      @mensaje[:echo] = false

      if current_user
        @mensaje[:user] = current_user.username
      else
        @mensaje[:user] = '_non_reg'
      end

      the_irc_gateway = IRCGateway.instance

      #mensaje_raw = the_irc_gateway.message_processor.generate_terminal_user_output @mensaje
      mensaje_raw = FayeMessagesController.new.generate_chat_output @mensaje

      send_via_faye "#{FAYE_CHANNEL_PREFIX}#{@mensaje[:channel]}", mensaje_raw

    end

    render :nothing => true
  end

  private
  # Get practica, associated users and devices
  def get_practice
    @practica = Practica.find(params[:id], :include => [:users, :dispositivos])
    @dispositivos_reservados = @practica.dispositivos
    @allowed_users = @practica.users
  end

  # Sends the echo so that the message one user sends can be seen by other users
  def faye_send mensaje
    send_via_faye "#{FAYE_CHANNEL_PREFIX}#{mensaje[:channel]}", mensaje.to_json
  end

  def initialize_faye_session_keys
    session[:faye] ||= {}

    #ActiveRecord::SessionStore::Session.all.each do |ses|
    #  puts "Session #{ses.id} class #{ses.class}"
    #  puts "Session #{ses.id} presence #{ses.presence}"
    #  puts "Session #{ses.id} hash #{ses.hash}"
    #  puts "Session #{ses.id} to_param #{ses.to_param}"
    #  puts "Session #{ses.id} to_s #{ses.to_s}"
    #  puts "Session #{ses.id} data #{ses.data}"
    #  puts "Session #{ses.id} data.class #{ses.data.class}"
    #  puts "Session #{ses.id} data.eql #{session.eql? ses.data}"
    #  puts "Session #{ses.id} data.eqskl #{session.eql? ses.data.symbolize_keys}"
    #  puts "Session #{ses.id} data.sy #{ses.data[:faye]}"
    #  puts "Session #{ses.id} data.syk #{ses.data.symbolize_keys}"
    #  puts "Session #{ses.id} data.sykf #{ses.data.symbolize_keys[:faye]}"
    #  puts "Session #{ses.id} data.st #{ses.data['faye']}"
    #
    #end
  end

end