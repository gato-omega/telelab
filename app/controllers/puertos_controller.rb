class PuertosController < AuthorizedController

  def index
    @puertos = Puerto.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @puertos }
    end
  end

  def show
    @puerto = Puerto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @puerto }
    end
  end

  def new
    @puerto = Puerto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @puerto }
    end
  end

  def edit
    @puerto = Puerto.find(params[:id])
  end

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

  def destroy
    @puerto = Puerto.find(params[:id])
    @puerto.destroy

    respond_to do |format|
      format.html { redirect_to(puertos_url) }
      format.xml  { head :ok }
    end
  end

  #For tokeninput plugin!
  def json_puertos
    @puertos = Puerto.where("etiqueta like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json { render :json => @puertos.collect { |puerto| {:id => puerto.id, :name => puerto.etiqueta} } }
    end
  end

end
