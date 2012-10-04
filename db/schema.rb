# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121004012110) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "state"
    t.boolean  "accepted"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contracts", :force => true do |t|
    t.integer  "game_id"
    t.integer  "murderer_id"
    t.integer  "victim_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "executed_at"
    t.datetime "proved_at"
  end

  create_table "games", :force => true do |t|
    t.string   "title"
    t.text     "description",        :default => ""
    t.date     "assignment_start",   :default => '2012-09-08'
    t.date     "assignment_end"
    t.date     "game_start"
    t.date     "game_end"
    t.integer  "min_player",         :default => 0
    t.integer  "max_player",         :default => 1000
    t.boolean  "needs_confirmation", :default => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "started",            :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "course"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "term"
    t.datetime "last_login"
    t.datetime "deleted_at"
  end

end
