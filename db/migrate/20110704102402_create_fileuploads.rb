class CreateFileuploads < ActiveRecord::Migration
  def self.up
    create_table :fileuploads do |t|
      t.string :filename,:null=>false
      t.string :username,:null=>false
      t.string :title,:null=>false
      t.text :keywords
      t.string :fvisible, :default=>"private"
      t.timestamps
    end
  end

  def self.down
    drop_table :fileuploads
  end
end
