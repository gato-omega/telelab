class DeviceConnectionsController < ApplicationController
  # GET /device_connections
  # GET /device_connections.xml
  def index
    @device_connections = DeviceConnection.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @device_connections }
    end
  end

  # GET /device_connections/1
  # GET /device_connections/1.xml
  def show
    @device_connection = DeviceConnection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @device_connection }
    end
  end

  # GET /device_connections/new
  # GET /device_connections/new.xml
  def new
    @device_connection = DeviceConnection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @device_connection }
    end
  end

  # GET /device_connections/1/edit
  def edit
    @device_connection = DeviceConnection.find(params[:id])
  end

  # POST /device_connections
  # POST /device_connections.xml
  def create
    @device_connection = DeviceConnection.new(params[:device_connection])

    respond_to do |format|
      if @device_connection.save
        format.html { redirect_to(@device_connection, :notice => 'Device connection was successfully created.') }
        format.xml  { render :xml => @device_connection, :status => :created, :location => @device_connection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @device_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /device_connections/1
  # PUT /device_connections/1.xml
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

  # DELETE /device_connections/1
  # DELETE /device_connections/1.xml
  def destroy
    @device_connection = DeviceConnection.find(params[:id])
    @device_connection.destroy

    respond_to do |format|
      format.html { redirect_to(device_connections_url) }
      format.xml  { head :ok }
    end
  end
end
