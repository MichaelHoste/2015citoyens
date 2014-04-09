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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140408193620) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "picture_link"
    t.string   "gender"
    t.string   "locale"
    t.integer  "f_id",           limit: 8
    t.string   "f_token"
    t.string   "f_first_name"
    t.string   "f_middle_name"
    t.string   "f_last_name"
    t.string   "f_username"
    t.string   "f_location"
    t.string   "f_location_id"
    t.string   "f_link"
    t.integer  "f_timezone"
    t.datetime "f_updated_time"
    t.boolean  "f_verified"
    t.boolean  "f_expires"
    t.datetime "f_expires_at"
    t.integer  "x"
    t.integer  "y"
    t.text     "description"
    t.boolean  "published",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  add_index "users", ["f_id"], name: "index_users_on_f_id", unique: true, using: :btree
  add_index "users", ["published"], name: "index_users_on_published", using: :btree
  add_index "users", ["x", "y"], name: "index_users_on_x_and_y", using: :btree

end
