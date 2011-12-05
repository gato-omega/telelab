class TeacherController < ApplicationController

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to home_path
  end

  before_filter :authenticate_user!
  before_filter :authenticate_teacher

  def index
  end

  def practicas
    @practicas = current_user.practicas
    render 'practicas/index'
  end

  def courses
    @courses = current_user.courses
    render 'courses/index'
  end

  def students
    @students = current_user.students
    render 'students/index'
  end

  private
  def authenticate_teacher
    authorize! :do_teacher_stuff, :stuff
  end

end
