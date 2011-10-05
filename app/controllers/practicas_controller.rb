class PracticasController < AuthorizedController

  respond_to :html, :only => [:index, :show, :new, :edit]
  before_filter :get_practice, :only => [:show, :edit, :lab, :make_practice]

  include CustomFayeSender



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
    channel_sym = "practica_#{@practica.id}".to_sym
    if current_user.options[:faye][channel_sym].nil?
      current_user.options[:faye][channel_sym] = :available

      if current_user.save
        #Send notification
        broadcast_chat_status channel_sym, :available
      end
    end

    @channel = channel_sym
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
        @mensaje[:user] = 'unregistered_user'
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

  # Generates JS for practica
  def lab
    @faye_channels = @dispositivos_reservados.map do |dispositivo| "#{FAYE_CHANNEL_PREFIX}device_#{dispositivo.id}" end
    @faye_channels << "#{FAYE_CHANNEL_PREFIX}practica_#{@practica.id}"
    @faye_server_url = FAYE_SERVER_URL

    if current_user
      @username = current_user.username
      @user_id = current_user.id
    else
      @username = '_non_reg'
      @user_id = -1
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

  def chat_status
    channel = "practica_#{params[:id]}"
    status = params[:status]
    if status.eql? 'offline'
      current_user.options[:faye].delete channel.to_sym
    else
      current_user.options[:faye][(channel.to_sym)] = status.to_sym
    end

    if current_user.save
      broadcast_chat_status channel, status
      render :nothing => true
    else
      render :status => 500
    end
  end


  def practice_events
    @practice_events = Practica.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @practice_events.collect { |event| {:title => event.name, :start => event.start, :end => event.end} } }
    end
  end

  def free_devices
    _start = DateTime.parse params[:start]
    _end = DateTime.parse params[:end]
    p '###################################'
    p 'Inicio de practica seleccionada ' + _start.to_s
    p 'Fin de practica seleccionada ' + _end.to_s
    p '###################################'
    Practica.all.each do |prac|
      if (prac.start > _start)
        p 'inicio de ' + prac.name + ' = ' + ' es mayor'
      elsif (prac.start < _start)
        p 'inicio de ' + prac.name + ' es menor'
      end
      if (prac.end > _end)
        p 'fin de ' + prac.name + ' es mayor'
      elsif (prac.end < _end)
        p 'fin de ' + prac.name + ' es menor'
      end
    end
    p '###################################'
    practicas = Practica.where(((:start >= _start) & (:end <= _end)) | ((:start < _start) & (:end > _start)) | ((:start < _end) & (:end > _end)) | ((:start <= _start) & (:end >= _end)))
    p practicas
    render :nothing => true
  end

  # THIS IS PRIVATE !!!
  private

  # Get practica, associated users and devices
  def get_practice
    @practica = Practica.find(params[:id], :include => [:users, :dispositivos])
    @dispositivos_reservados = @practica.dispositivos
    @allowed_users = @practica.users
  end

  def broadcast_chat_status(channel, status)
    mensaje_raw = FayeMessagesController.new.generate_chat_status_output current_user.id, status
    send_via_faye "#{FAYE_CHANNEL_PREFIX}#{channel}", mensaje_raw
  end



end