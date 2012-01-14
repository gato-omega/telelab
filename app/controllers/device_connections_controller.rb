class DeviceConnectionsController < AuthorizedController

  before_filter :get_puertos, :only => [:new, :update, :create, :edit]

  def index
    @device_connections = DeviceConnection.without_duplicates

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @device_connections }
    end
  end

  def show
    @device_connection = DeviceConnection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @device_connection }
    end
  end

  def new
    @device_connection = DeviceConnection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @device_connection }
    end
  end

  def edit
    @device_connection = DeviceConnection.find(params[:id])
  end

  def create
    @device_connection = DeviceConnection.new(params[:device_connection])
    p = @device_connection.puerto
    e = @device_connection.endpoint

    respond_to do |format|
      begin
        p.conectar_fisicamente e
        format.html { redirect_to(@device_connection, :notice => 'Device connection was successfully created.') }
        format.xml  { render :xml => @device_connection, :status => :created, :location => @device_connection }
      rescue
        format.html { render :action => "new" }
        format.xml  { render :xml => @device_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @device_connection = DeviceConnection.find(params[:id])

    respond_to do |format|
      if @device_connection.update_attributes(params[:device_connection])
        format.html { redirect_to(@device_connection, :notice => 'Device connection was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @device_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @device_connection = DeviceConnection.find(params[:id])
    #@device_connection.destroy

    p = @device_connection.puerto

    p.desconectar_fisicamente

    respond_to do |format|
      format.html { redirect_to(device_connections_url) }
      format.xml  { head :ok }
    end
  end

  def get_puertos
    @puertos = Puerto.all
    @puertos.collect! do |p|
      if p.dispositivo
        ["#{p.dispositivo.nombre} - #{p.etiqueta}",p.id]
      else
        ["N/A - #{p.etiqueta}",p.id]
      end
    end
  end
end
