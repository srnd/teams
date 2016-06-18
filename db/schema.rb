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

ActiveRecord::Schema.define(version: 20160618210137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "appid",          limit: 255
    t.string   "secret",         limit: 255
    t.string   "oauth_callback", limit: 255
  end

  create_table "awards", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "team_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
    t.integer  "event_id"
    t.string   "notes",       limit: 255
  end

  create_table "batches", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "awards_shown"
    t.integer  "year"
    t.string   "clear_id"
    t.datetime "starts_at"
  end

  create_table "events", force: :cascade do |t|
    t.string   "city",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clear_id"
    t.string   "webname"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "text"
    t.string   "thumbnail_url"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tags_teams", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "team_id"
  end

  add_index "tags_teams", ["tag_id"], name: "index_tags_teams_on_tag_id", using: :btree
  add_index "tags_teams", ["team_id"], name: "index_tags_teams_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "code",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "batch_id"
    t.text     "extra"
    t.text     "project_description"
    t.string   "project_url"
    t.string   "team_photo_url"
    t.string   "youtube_url"
    t.string   "short_description"
    t.string   "download_url"
    t.string   "website_url"
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token",   limit: 255
    t.integer  "user_id"
    t.integer  "application_id"
    t.string   "token_string",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",    limit: 255
    t.boolean  "admin"
    t.string   "password",    limit: 255
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.string   "salt",        limit: 255
    t.boolean  "judge"
    t.integer  "event_id"
    t.boolean  "legacy"
    t.string   "s5_username", limit: 255
    t.string   "email",       limit: 255
    t.string   "s5_token",    limit: 255
    t.boolean  "superadmin"
    t.boolean  "volunteer"
  end

end
