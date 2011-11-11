class HorariosController < ApplicationController
  # GET /horarios
  # GET /horarios.xml
  def index
    @horarios = Horario.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @horarios }
    end
  end

  # GET /horarios/1
  # GET /horarios/1.xml
  def show
    @horario = Horario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @horario }
    end
  end

  # GET /horarios/new
  # GET /horarios/new.xml
  def new
    @horario = Horario.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @horario }
    end
  end

  # GET /horarios/1/edit
  def edit
    @horario = Horario.find(params[:id])
  end

  # POST /horarios
  # POST /horarios.xml
  def create
    @horario = Horario.new(params[:horario])

    respond_to do |format|
      if @horario.save
        format.html { redirect_to(@horario, :notice => 'Horario was successfully created.') }
        format.xml  { render :xml => @horario, :status => :created, :location => @horario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @horario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /horarios/1
  # PUT /horarios/1.xml
  def update
    @horario = Horario.find(params[:id])

    respond_to do |format|
      if @horario.update_attributes(params[:horario])
        format.html { redirect_to(@horario, :notice => 'Horario was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @horario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /horarios/1
  # DELETE /horarios/1.xml
  def destroy
    @horario = Horario.find(params[:id])
    @horario.destroy

    respond_to do |format|
      format.html { redirect_to(horarios_url) }
      format.xml  { head :ok }
    end
  end
end
