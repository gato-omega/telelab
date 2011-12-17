class CoursesController < AuthorizedController

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      redirect_to courses_path, :notice => "Successfully created course."
    else
      render :action => 'new'
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      redirect_to courses_path, :notice  => "Successfully updated course."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @course = Course.find(params[:id])
    redirect_to courses_path, :notice => "Se ha eliminado el curso #{@course.name}." if @course.destroy
  end

  def register
    @course = Course.find(params[:id])
    password = params[:password]
    if password.eql? @course.password
      @course.users << current_user
      redirect_to @course, :notice => "Te has registrado correctamente en el curso #{@course.name}."
    else
      redirect_to @course, :alert => "El password de matricula no corresponde!"
    end
  end

  def unregister
    @course = Course.find(params[:id])
    if @course.users.delete current_user
      redirect_to @course, :notice => "Has abandonado el curso #{@course.name}."
    else
      redirect_to @course, :alert => "El password de matricula no corresponde!"
    end
  end

  def register_teachers
    teacher_list = params[:teacher_list]
    if teacher_list
      @course = Course.find(params[:id])
      @course.teacher_ids = teacher_list.split ','
      render :action => 'show'
    else
      render :nothing => true
    end
  end

  def teachers
    @course = Course.find(params[:id])
    @teachers = @course.teachers
    format :json => @teachers
  end
  
end
