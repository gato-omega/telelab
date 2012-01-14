class VlansController < AuthorizedController
  def index
    @vlans = Vlan.all
  end

  def show
    @vlan = Vlan.find(params[:id])
  end

  def new
    @vlan = Vlan.new
  end

  def create
    @vlan = Vlan.new(params[:vlan])
    if @vlan.save
      redirect_to @vlan, :notice => "Successfully created vlan."
    else
      render :action => 'new'
    end
  end

  def edit
    @vlan = Vlan.find(params[:id])
  end

  def update
    @vlan = Vlan.find(params[:id])
    if @vlan.update_attributes(params[:vlan])
      redirect_to @vlan, :notice  => "Successfully updated vlan."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @vlan = Vlan.find(params[:id])
    @vlan.destroy
    redirect_to vlans_url, :notice => "Successfully destroyed vlan."
  end
end