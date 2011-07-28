class DispositivosController < ApplicationController
  # GET /dispositivos
  # GET /dispositivos.xml
  def index
    @dispositivos = Dispositivo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dispositivos }
    end
  end

  # GET /dispositivos/1
  # GET /dispositivos/1.xml
  def show
    @dispositivo = Dispositivo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dispositivo }
    end
  end

  # GET /dispositivos/new
  # GET /dispositivos/new.xml
  def new
    @dispositivo = Dispositivo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dispositivo }
    end
  end

  # GET /dispositivos/1/edit
  def edit
    @dispositivo = Dispositivo.find(params[:id])
  end

  # POST /dispositivos
  # POST /dispositivos.xml
  def create
    @dispositivo = Dispositivo.new(params[:dispositivo])

    respond_to do |format|
      if @dispositivo.save
        format.html { redirect_to(@dispositivo, :notice => 'Dispositivo was successfully created.') }
        format.xml  { render :xml => @dispositivo, :status => :created, :location => @dispositivo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dispositivo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dispositivos/1
  # PUT /dispositivos/1.xml
  def update
    @dispositivo = Dispositivo.find(params[:id])

    respond_to do |format|
      if @dispositivo.update_attributes(params[:dispositivo])
        format.html { redirect_to(@dispositivo, :notice => 'Dispositivo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dispositivo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dispositivos/1
  # DELETE /dispositivos/1.xml
  def destroy
    @dispositivo = Dispositivo.find(params[:id])
    @dispositivo.destroy

    respond_to do |format|
      format.html { redirect_to(dispositivos_url) }
      format.xml  { head :ok }
    end
  end
end
