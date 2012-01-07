class UsersController < AuthorizedController

  def index
    #How to use
    #@users = User.where(:type => 'Technician').all_without_typecast

    @users = User.all_without_typecast
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])
    @user = @user.userize

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @user = User.new
    @roles = User::ROLES

    @user.build_profile
    
    @current_method = "new"

    respond_to do |format|
      format.html # new.html.erb
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
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user = @user.userize
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end

  #For tokeninput plugin!
  def json_users
    @all_users = User.search(:profile_firstname_or_profile_lastname_contains =>  params[:q], :courses_id_in => (current_user.courses.map {|c| c.id}))
    respond_to do |format|
      format.json { render :json => @all_users.relation.uniq.collect { |user| {:id => user.id, :name => user.username} } }
    end
  end

end
