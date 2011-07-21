class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.references :port
      t.references :endpoint
    end
  end

  def self.down
    drop_table :connections
  end
end
