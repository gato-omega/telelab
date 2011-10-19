class AdminsController < ApplicationController

  respond_to :html, :xml, :only => [:index, :show, :new, :edit]

  def index
    @admins = Admin.all
    respond_with @admins
  end

  def show
    @admin = Admin.find(params[:id])
    respond_with @admin
  end

  def new
    @admin = Admin.new
    @admin.build_profile
    @current_method = "new"
    respond_with @admin
  end

  def edit
    @admin = Admin.find(params[:id])
    respond_with @admin
  end

  def create
    @admin = Admin.new(params[:admin])
    @current_method = "new"
    
    respond_to do |format|
      if @admin.save
        format.html { redirect_to(admins_url, :notice => 'admin was successfully created.') }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        format.html { redirect_to(admins_url, :notice => 'admin was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end

end
