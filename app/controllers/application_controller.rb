class ApplicationController < ActionController::Base
  protect_from_forgery

  # Check layout on user type
  layout :per_user_layout

  protected
  # Use layout depending on user type
  def per_user_layout
    if current_user.is_a? Admin
      'admin'
    elsif current_user.is_a? Student
      'student'
    elsif current_user.is_a? Technician
      'technician'
    elsif current_user.is_a? Teacher
      'teacher'
    else #Not signed in
      'application'
    end
  end

end
