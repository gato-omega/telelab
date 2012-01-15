class RegistrationsController < ApplicationController

  respond_to :html, :only => [:register, :register_sign_in]

  def register
    @student = Student.new
    @student.build_profile
    @current_method = "new"
    respond_with @student
  end

  def register_sign_in
    @student = Student.new(params[:student])
    @current_method = "new"
    @student.type = 'Student'

    respond_to do |format|
      if @student.save
        sign_in @student
        format.html { redirect_to(student_home_path, :notice => 'Su cuenta ha sido creada satisfactoriamente') }
      else
        format.html { render :action => "register" }
      end
    end
  end

end
