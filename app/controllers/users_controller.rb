class UsersController < ApplicationController

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    @users = any_to_user_class @users
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @user = any_to_user_class @user

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @roles = User::ROLES

    @current_method = "new"

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user = any_to_user_class @user
    @roles = User::ROLES
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    @roles = User::ROLES
    @current_method = "new"

    logger.debug("WHAT THE FUCKING HELL?? - index")
    logger.debug(@user.to_yaml)
    logger.debug params
    logger.debug params[:user]

    #@user = any_to_user_class @user
    
    #print @user.to_yaml

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

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user = any_to_user_class @user
    
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

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml { head :ok }
    end
  end

  private

  #This method turns any Admin, Student,... subclass of User and puts it back to User
  def any_to_user_class(_collection)
    if _collection.is_a? Array
      _collection.collect! do |user|
        user.becomes(User)
      end
      _collection
    else
      _collection.becomes(User)
    end
  end

end
