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

ActiveRecord::Schema.define(version: 20150220022033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "appid"
    t.string   "secret"
    t.string   "oauth_callback"
  end

  create_table "awards", force: true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
    t.integer  "event_id"
    t.string   "notes"
  end

  create_table "batches", force: true do |t|
    t.string   "name"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project"
    t.integer  "event_id"
    t.integer  "batch_id"
  end

  create_table "teams_users", id: false, force: true do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
  end

  create_table "tokens", force: true do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.integer  "application_id"
    t.string   "token_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.boolean  "admin"
    t.string   "password"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "salt"
    t.boolean  "judge"
    t.integer  "event_id"
    t.boolean  "legacy"
    t.string   "s5_username"
    t.string   "email"
    t.string   "s5_token"
  end

end
