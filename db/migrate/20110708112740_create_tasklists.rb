class CreateTasklists < ActiveRecord::Migration
  def self.up
    create_table :tasklists do |t|
       t.string :subject,:null=>false
       t.date :startdate,:null=>false
       t.date :targetdate,:null=>false
       t.string :currentstatus
       t.string :filename
       t.string :priority,:default=>"medium"
       t.string :username,:null=>false
       t.string :assignedto
       t.string :tvisible,:default=>"private"
       t.string :tasktype,:null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :tasklists
  end
end
