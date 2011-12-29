class Teacher < User
  #has_and_belongs_to_many :courses, :join_table => 'users_courses', :foreign_key => 'user_id', :uniq => true
  #has_many :users, :through => :courses, :uniq => true, :source => :user

  def students
    my_students = []
    courses.each do |course|
      my_students += course.students
    end
    my_students.uniq
  end
end
