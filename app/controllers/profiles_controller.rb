class ProfilesController < AuthorizedController

  before_filter :get_profile, :only => [:edit, :show]

  def edit
    @profile = User.find_by_username(params[:username]).profile
  end

  def show
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to(home_path, :notice => 'Profile was successfully updated.')
    else
      render :action => "edit"
    end
  end

  private

  def get_profile
    @profile = User.find_by_username(params[:username]).profile
  end
end
