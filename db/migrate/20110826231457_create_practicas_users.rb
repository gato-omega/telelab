class CreatePracticasUsers < ActiveRecord::Migration
  def self.up
    create_table :practicas_users, :id => false do |t|
      t.references :practica
      t.references :user
    end
  end

  def self.down
    drop_table :practicas_users
  end
end