class TeachersController < AuthorizedController

  respond_to :html, :xml, :only => [:index, :show, :new, :edit]

  def index
    @teachers = Teacher.all
    respond_with @teachers
  end

  def show
    @teacher = Teacher.find(params[:id])
    respond_with @teacher
  end

  def new
    @teacher = Teacher.new
    @teacher.build_profile
    @current_method = "new"
    respond_with @teacher
  end

  def edit
    @teacher = Teacher.find(params[:id])
    respond_with @teacher
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    @current_method = "new"

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to(teachers_url, :notice => 'Teacher was successfully created.') }
        format.xml  { render :xml => @teacher, :status => :created, :location => @teacher }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html { redirect_to(teachers_url, :notice => 'Teacher was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy

    respond_to do |format|
      format.html { redirect_to(teachers_url) }
      format.xml  { head :ok }
    end
  end
end
