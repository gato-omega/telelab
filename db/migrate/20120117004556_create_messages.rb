class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :practica
      t.references :dispositivo
      t.references :user
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
