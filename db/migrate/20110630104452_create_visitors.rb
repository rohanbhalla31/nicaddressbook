class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.string :name,:null=>false
      t.string :address
      t.string :phoneno
      t.string :company,:null=>false
      t.date :dateofvisit
      t.string :officer,:null=>false
      t.string :designation
      t.string :username,:null=>false
      t.string :email
      t.string :visible,:default=>"private"
      t.timestamps
    end
  end

  def self.down
    drop_table :visitors
  end
end
