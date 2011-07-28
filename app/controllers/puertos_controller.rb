class PuertosController < ApplicationController
  # GET /puertos
  # GET /puertos.xml
  def index
    @puertos = Puerto.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @puertos }
    end
  end

  # GET /puertos/1
  # GET /puertos/1.xml
  def show
    @puerto = Puerto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @puerto }
    end
  end

  # GET /puertos/new
  # GET /puertos/new.xml
  def new
    @puerto = Puerto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @puerto }
    end
  end

  # GET /puertos/1/edit
  def edit
    @puerto = Puerto.find(params[:id])
  end

  # POST /puertos
  # POST /puertos.xml
  def create
    @puerto = Puerto.new(params[:puerto])

    respond_to do |format|
      if @puerto.save
        format.html { redirect_to(@puerto, :notice => 'Puerto was successfully created.') }
        format.xml  { render :xml => @puerto, :status => :created, :location => @puerto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @puerto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /puertos/1
  # PUT /puertos/1.xml
  def update
    @puerto = Puerto.find(params[:id])

    respond_to do |format|
      if @puerto.update_attributes(params[:puerto])
        format.html { redirect_to(@puerto, :notice => 'Puerto was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @puerto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /puertos/1
  # DELETE /puertos/1.xml
  def destroy
    @puerto = Puerto.find(params[:id])
    @puerto.destroy

    respond_to do |format|
      format.html { redirect_to(puertos_url) }
      format.xml  { head :ok }
    end
  end
end
