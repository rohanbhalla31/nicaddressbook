class CreateTasktypes < ActiveRecord::Migration
  def self.up
    create_table :tasktypes do |t|
      t.string :tasktype,:null=>false 
      t.timestamps
    end
  end

  def self.down
    drop_table :tasktypes
  end
end
