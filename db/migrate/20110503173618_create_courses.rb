class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :matriculate_password
      t.string :options
      #t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
