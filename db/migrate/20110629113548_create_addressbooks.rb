class CreateAddressbooks < ActiveRecord::Migration
  def self.up
    create_table :addressbooks do |t|
          t.string :name,:null=>false
          t.string :username,:null=>false
          t.string :salt,:null=>false
          t.string :hashed_password,:null=>false
          t.string :phoneno,:null=>false
          t.string :designation,:null=>false
          t.string :role,:null=>false
          t.string :email, :null=>false
          t.timestamps
    end
  end

  def self.down
    drop_table :addressbooks
  end
end
