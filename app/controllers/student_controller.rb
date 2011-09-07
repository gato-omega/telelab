class StudentController < ApplicationController

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to home_path
  end

  before_filter :authenticate_user!

  def index
    authorize! :do_student_stuff, :stuff
  end

end
