class TechniciansController < AuthorizedController

  respond_to :html, :xml, :only => [:index, :show, :new, :edit]

  def index
    @technicians = Technician.all
    respond_with @technicians
  end

  def show
    @technician = Technician.find(params[:id])
    respond_with @technician
  end

  def new
    @technician = Technician.new
    @technician.build_profile
    @current_method = "new"
    respond_with @technician
  end

  def edit
    @technician = Technician.find(params[:id])
    respond_with @technician
  end

  def create
    @technician = Technician.new(params[:technician])
    @current_method = "new"

    respond_to do |format|
      if @technician.save
        format.html { redirect_to(technicians_url, :notice => 'Technician was successfully created.') }
        format.xml  { render :xml => @technician, :status => :created, :location => @technician }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @technician.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @technician = Technician.find(params[:id])

    respond_to do |format|
      if @technician.update_attributes(params[:technician])
        format.html { redirect_to(technicians_url, :notice => 'Technician was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @technician.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @technician = Technician.find(params[:id])
    @technician.destroy

    respond_to do |format|
      format.html { redirect_to(technicians_url) }
      format.xml  { head :ok }
    end
  end

end
