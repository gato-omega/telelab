class CreateUsersCourses < ActiveRecord::Migration
  def self.up
    create_table :users_courses, :id => false do |t|
      t.references :user
      t.references :course
    end
  end

  def self.down
    drop_table :users_courses
  end
end
