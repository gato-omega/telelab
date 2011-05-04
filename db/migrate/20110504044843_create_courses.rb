class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :hashed_password
      t.string :options
      #t.timestamps
    end

    add_index :courses, :name

  end

  def self.down
    drop_table :courses
  end
end
