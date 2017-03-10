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

ActiveRecord::Schema.define(version: 20170310195456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artworks", force: :cascade do |t|
    t.string   "title"
    t.string   "artist"
    t.string   "description"
    t.decimal  "map_lat"
    t.decimal  "map_long"
    t.string   "address"
    t.string   "pkey"
    t.integer  "user_id"
    t.integer  "neighborhood_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
    t.integer  "organization_id"
    t.index ["neighborhood_id"], name: "index_artworks_on_neighborhood_id", using: :btree
    t.index ["organization_id"], name: "index_artworks_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_artworks_on_user_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "host_contact"
    t.string   "description"
    t.decimal  "map_lat"
    t.decimal  "map_long"
    t.string   "address"
    t.date     "date"
    t.time     "time"
    t.string   "pkey"
    t.integer  "user_id"
    t.integer  "neighborhood_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
    t.integer  "organization_id"
    t.index ["neighborhood_id"], name: "index_events_on_neighborhood_id", using: :btree
    t.index ["organization_id"], name: "index_events_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name"
    t.decimal  "map_lat"
    t.decimal  "map_long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organization_neighborhoods", force: :cascade do |t|
    t.integer "neighborhood_id"
    t.integer "organization_id"
    t.index ["neighborhood_id"], name: "index_organization_neighborhoods_on_neighborhood_id", using: :btree
    t.index ["organization_id"], name: "index_organization_neighborhoods_on_organization_id", using: :btree
  end

  create_table "organization_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
    t.index ["organization_id"], name: "index_organization_users_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_organization_users_on_user_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "description"
    t.decimal  "map_lat"
    t.decimal  "map_long"
    t.string   "address"
    t.string   "pkey"
    t.integer  "user_id"
    t.integer  "neighborhood_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
    t.text     "body"
    t.integer  "organization_id"
    t.index ["neighborhood_id"], name: "index_stories_on_neighborhood_id", using: :btree
    t.index ["organization_id"], name: "index_stories_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_stories_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "role",            default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "neighborhood_id"
    t.index ["neighborhood_id"], name: "index_users_on_neighborhood_id", using: :btree
  end

  add_foreign_key "artworks", "neighborhoods"
  add_foreign_key "artworks", "organizations"
  add_foreign_key "artworks", "users"
  add_foreign_key "events", "neighborhoods"
  add_foreign_key "events", "organizations"
  add_foreign_key "events", "users"
  add_foreign_key "organization_neighborhoods", "neighborhoods"
  add_foreign_key "organization_neighborhoods", "organizations"
  add_foreign_key "organization_users", "organizations"
  add_foreign_key "organization_users", "users"
  add_foreign_key "stories", "neighborhoods"
  add_foreign_key "stories", "organizations"
  add_foreign_key "stories", "users"
  add_foreign_key "users", "neighborhoods"
end
