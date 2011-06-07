class Student < User
  has_and_belongs_to_many :courses, :join_table => 'users_courses'
end