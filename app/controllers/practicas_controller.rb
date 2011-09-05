class PracticasController < ApplicationController

  def index
    @practicas = Practica.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @practicas }
    end
  end

  def show
    @practica = Practica.find(params[:id])
    @dispositivos = @practica.dispositivos
    @allowed_users = @practica.users

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @practica }
    end
  end

  def new
    @practica = Practica.new
    @dispositivos = Dispositivo.all
    @dispositivos_reservados = @practica.dispositivos
    @allowed_users = []

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @practica }
    end
  end

  def edit
    @practica = Practica.find(params[:id])
    @dispositivos = Dispositivo.all
    @dispositivos_reservados = @practica.dispositivos
    @allowed_users = @practica.users
  end

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

  def destroy
    @practica = Practica.find(params[:id])
    @practica.destroy

    respond_to do |format|
      format.html { redirect_to(practicas_url) }
      format.xml { head :ok }
    end
  end

  def make_practice
    @practica = Practica.find(params[:id])
    @dispositivos_reservados = @practica.dispositivos
    @allowed_users = @practica.users
  end

end