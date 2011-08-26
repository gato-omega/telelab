class CreatePracticas < ActiveRecord::Migration
  def self.up
    create_table :practicas do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.string :estado

      t.timestamps
    end
  end

  def self.down
    drop_table :practicas
  end
end
