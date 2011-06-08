class PassThroughController < ApplicationController

  #Redirects to the apporpiate ''domain'
  def index

    # Admin
    if current_user.is_a? Admin
      redirect_to admin_panel_path
    elsif current_user.is_a? Student
      redirect_to welcome_path
    elsif current_user.is_a? Technician
      redirect_to welcome_path
    elsif current_user.is_a? Teacher
      redirect_to welcome_path
    else #Not signed in
      redirect_to welcome_path
    end

  end

end
