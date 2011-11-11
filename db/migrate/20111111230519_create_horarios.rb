class CreateHorarios < ActiveRecord::Migration
  def self.up
    create_table :horarios do |t|
      t.references :course
    end
  end

  def self.down
    drop_table :horarios
  end
end
