class PassThroughController < ApplicationController

  #Redirects to the apporpiate ''domain'
  def index

    # Admin
    if current_user.is_a? Admin
      redirect_to admin_home_path
    elsif current_user.is_a? Student
      redirect_to student_home_path
    elsif current_user.is_a? Technician
      redirect_to technician_home_path
    elsif current_user.is_a? Teacher
      redirect_to teacher_home_path
    else #Not signed in
      redirect_to home_path
    end

  end

end
