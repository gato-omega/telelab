class TechnicianController < ApplicationController

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to home_path
  end

  before_filter :authenticate_user!

  def index
    authorize! :do_technician_stuff, :stuff
  end

end
