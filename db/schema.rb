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

ActiveRecord::Schema.define(:version => 20120818212052) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "timezone"
    t.string   "location"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "fb_event_id", :limit => 8
  end

  add_index "events", ["location"], :name => "index_events_on_location"
  add_index "events", ["name"], :name => "index_events_on_name", :unique => true

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "rsvp_status"
    t.string   "teaser_users"
    t.integer  "num_friends_attending"
    t.integer  "num_friends_maybe"
    t.integer  "num_friends_invited"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "user_events", ["event_id"], :name => "index_user_events_on_event_id"
  add_index "user_events", ["num_friends_attending"], :name => "index_user_events_on_num_friends_attending"
  add_index "user_events", ["num_friends_invited"], :name => "index_user_events_on_num_friends_invited"
  add_index "user_events", ["num_friends_maybe"], :name => "index_user_events_on_num_friends_maybe"
  add_index "user_events", ["user_id", "event_id"], :name => "index_user_events_on_user_id_and_event_id", :unique => true
  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "token"
    t.integer  "expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "fb_id"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["fb_id"], :name => "index_users_on_fb_id", :unique => true
  add_index "users", ["token"], :name => "index_users_on_token", :unique => true

end
