class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :firstname
      t.string :lastname
      t.string :codigo
      t.references :user
    end

    add_index :profiles, :codigo

  end

  def self.down
    drop_table :profiles
  end
end
