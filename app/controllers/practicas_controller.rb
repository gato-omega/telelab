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
    @show_first = false
    ap @practica.event.start
    ap @practica.event.end
  end

  def edit
    @show_first = true
  end

  def create
    @practica = Practica.new(params[:practica])
    @practica.users << current_user
    respond_to do |format|
      if @practica.save
        format.html { redirect_to(@practica, :notice => 'Practica was successfully created.') }
        practice_jobs @practica, 'created'
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
        @practica.users << current_user unless (@practica.users.include? current_user)
        format.html { redirect_to(@practica, :notice => 'Practica was successfully updated.') }
        practice_jobs @practica, 'updated'
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def update_diagram
    @practica = Practica.find(params[:id])
    @success = true
    valid_params = params.select {|k,v| [:image, :remote_image_url].include? k}
    respond_to do |format|
      if @practica.update_attributes(valid_params)
      else
        @success = false
      end
      format.js
    end
  end

  def destroy
    @practica.destroy

    #for destroy delayed_jobs
    Delayed::Job.where("handler like ?", "%practice_id: #{@practica.id}%").destroy_all

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
    else
      broadcast_chat_status channel_sym, current_user.options[:faye][channel_sym]
    end

    @channel = channel_sym
    @logical_connections = Vlan.where(:practica_id >> @practica.id)
    @conexion = Vlan.new

    @puertos = []
    @dispositivos_reservados.each do |dispositivo|
      @puertos += dispositivo.puertos
    end

    @puertos = @puertos.uniq
    # See which vlans exist
    #@practica.vlans.each do |vlan|
    #  p1 = vlan.puerto
    #  p2 = vlan.endpoint
    #  @puertos.delete_if {|un_puerto| (un_puerto.id == p1.id || un_puerto.id == p2.id)}
    #end

    @puertos.collect! do |p|
      if p.dispositivo
        ["#{p.dispositivo.nombre} - #{p.etiqueta}",p.id]
      else
        ["N/A - #{p.etiqueta}",p.id]
      end
    end

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
      the_irc_gateway.send_irc("##{@mensaje[:channel]}", @mensaje[:message])
    end

    render :nothing => true

  end

  # Generates JS for practica
  def lab
    @faye_channels = @dispositivos_reservados.map do |dispositivo|
      "#{FAYE_CHANNEL_PREFIX}device_#{dispositivo.id}"
    end
    @faye_channels << "#{FAYE_CHANNEL_PREFIX}practica_#{@practica.id}"
    @faye_server_url = FAYE_SERVER_URL

    if current_user
      @username = current_user.username
      @user_id = current_user.id
    else
      @username = '_non_reg'
      @user_id = -1
    end

    @puertos = []
    @dispositivos_reservados.each do |dispositivo|
      @puertos += dispositivo.puertos
    end

    @puertos = @puertos.uniq

    #See which vlans exist
    @practica.vlans.each do |vlan|
      p1 = vlan.puerto
      p2 = vlan.endpoint
      @puertos.each do |un_puerto|
        (un_puerto.id == p1.id || un_puerto.id == p2.id) ? un_puerto.runtime_state = :conectado : un_puerto.runtime_state = :libre
      end
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

      #mensaje_raw = the_irc_gateway.message_processor.faye_processor.generate_terminal_user_output @mensaje
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

  def new_conexion

    the_practica = Practica.find(params[:id])
    the_vlan = Vlan.new(params[:vlan])
    the_vlan.practica = the_practica

    #puts "DEBUG ##################3 practica is #{the_practica.inspect}"
    #
    #the_vlan = puerto.conectar_logicamente endpoint
    #
    #puts "DEBUG ##################3 the_vlan is #{the_vlan.inspect}"
    channel = "practica_#{the_practica.id}"

    if the_vlan.save
      IRCGateway.instance.create_vlan the_vlan
      mensaje_raw = FayeMessagesController.new.generate_new_conexion_output the_vlan
      send_via_faye "#{FAYE_CHANNEL_PREFIX}#{channel}", mensaje_raw
    else
      mensaje_raw = FayeMessagesController.new.generate_new_conexion_error_output the_vlan
      send_via_faye "#{FAYE_CHANNEL_PREFIX}#{channel}", mensaje_raw
    end

    render :nothing => true

  end

  def remove_conexion
    #@vlan = Vlan.find(params[:id])
    puts "############### FUNCIONA !!! #{params[:id]}, #{params[:con_id]}"
    vlan = Vlan.find(params[:con_id])
    if vlan.destroy
      channel = "practica_#{params[:id]}"
      mensaje_raw = FayeMessagesController.new.generate_remove_conexion_output vlan
      send_via_faye "#{FAYE_CHANNEL_PREFIX}#{channel}", mensaje_raw
    end
    render :nothing => true
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

    events = Event.where(((:start >= _start) & (:end <= _end)) | ((:start < _start) & (:end > _start)) | ((:start < _end) & (:end > _end)) | ((:start <= _start) & (:end >= _end)))
    events.map!{|event| event.eventable}
    filtered_practices = events.select{|eventable| eventable.is_a? Practica}
    #filtered_practices = Practica.exist_in_span(_start, _end)
    reserved_devices = []
    filtered_practices.each do |practica|
      reserved_devices += practica.dispositivos
    end
    reserved_devices = reserved_devices.uniq
    @dispositivos = Dispositivo.for_users.ok
    @free_devices = @dispositivos - reserved_devices
  end

  def practice_jobs practica, action
    if action.eql? 'created'
      time1 = practica.start - practica.created_at
      time2 = time1 + (practica.end - practica.start)
      Delayed::Job.enqueue(PracticeJob.new(practica.id, :open), 0, time1.seconds.from_now)
      Delayed::Job.enqueue(PracticeJob.new(practica.id, :close), 0, time2.seconds.from_now)
    elsif action.eql? 'updated'
      jobs = Delayed::Job.where("handler like ?", "%practice_id: #{practica.id}%")
      jobs.each do |job|
        if job.handler.include? 'open'
          job.update_attribute(:run_at, practica.start)
        elsif job.handler.include? 'close'
          job.update_attribute(:run_at, practica.end)
        end
      end
    end
  end

  # THIS IS PRIVATE !!!
  private

  # Get practica, associated users and devices
  def get_practice
    @practica = Practica.find(params[:id], :include => [:users, :dispositivos])
    @dispositivos_reservados = @practica.dispositivos
    @allowed_users = @practica.users
  end

  # Broadcast this user's chat status in a specific channel
  def broadcast_chat_status(channel, status)
    mensaje_raw = FayeMessagesController.new.generate_chat_status_output current_user, status
    send_via_faye "#{FAYE_CHANNEL_PREFIX}#{channel}", mensaje_raw
  end

end
