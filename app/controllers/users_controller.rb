class UsersController < AuthorizedController

  def index
    #How to use
    #@users = User.where(:type => 'Technician').all_without_typecast

    @users = User.all_without_typecast
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    @user = @user.userize

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end

  def new
    @user = User.new
    @roles = User::ROLES

    @user.build_profile
    
    @current_method = "new"

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
    @user = @user.userize
    @roles = User::ROLES
  end

  def create
    @user = User.new(params[:user])
    #@user = @user.userize # DONT EVER DO THIS IN CREATE -- hours wasted!
    #@user.type = 'Student'
    @roles = User::ROLES
    @current_method = "new"
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user = @user.userize
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml { head :ok }
    end
  end


  #For tokeninput plugin!
  def json_users
    @all_users = User.where("username like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json { render :json => @all_users.collect { |user| {:id => user.id, :name => user.username} } }
    end
  end

end
