# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110712071206) do

  create_table "addressbooks", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "username",        :null => false
    t.string   "salt",            :null => false
    t.string   "hashed_password", :null => false
    t.string   "phoneno",         :null => false
    t.string   "designation",     :null => false
    t.string   "role",            :null => false
    t.string   "email",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fileuploads", :force => true do |t|
    t.string   "filename",                          :null => false
    t.string   "username",                          :null => false
    t.string   "title",                             :null => false
    t.text     "keywords"
    t.string   "fvisible",   :default => "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasklists", :force => true do |t|
    t.string   "subject",                              :null => false
    t.date     "startdate",                            :null => false
    t.date     "targetdate",                           :null => false
    t.string   "currentstatus"
    t.string   "filename"
    t.string   "priority",      :default => "medium"
    t.string   "username",                             :null => false
    t.string   "assignedto"
    t.string   "tvisible",      :default => "private"
    t.string   "tasktype",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasktypes", :force => true do |t|
    t.string   "tasktype",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visitors", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "address"
    t.string   "phoneno"
    t.string   "company"
    t.date     "dateofvisit"
    t.string   "officer",                            :null => false
    t.string   "designation"
    t.string   "username",                           :null => false
    t.string   "email"
    t.string   "visible",     :default => "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
