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

ActiveRecord::Schema.define(version: 20161009021713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "challenge_members", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "email",             null: false
    t.integer  "challenge_team_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "challenge_members", ["email"], name: "index_challenge_members_on_email", unique: true, using: :btree

  create_table "challenge_teams", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "email",                          null: false
    t.string   "payment_method",                 null: false
    t.integer  "limit",          default: 10,    null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "payment_status", default: false, null: false
  end

  add_index "challenge_teams", ["email"], name: "index_challenge_teams_on_email", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",                                                null: false
    t.text     "description"
    t.string   "facilitator"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "kind"
    t.decimal  "price",         precision: 8, scale: 2, default: 0.0
    t.integer  "limit",                                 default: 0,   null: false
    t.integer  "event_type_id"
  end

  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree

  create_table "inscriptions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "package_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "inscriptions", ["user_id"], name: "index_inscriptions_on_user_id", unique: true, using: :btree

  create_table "packages", force: :cascade do |t|
    t.string   "title",                                             null: false
    t.text     "description"
    t.integer  "limit",                                             null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.decimal  "price",       precision: 8, scale: 2, default: 0.0
  end

  create_table "packages_events_types", force: :cascade do |t|
    t.integer  "event_type_id",             null: false
    t.integer  "package_id",                null: false
    t.integer  "limit",         default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "packages_events_types", ["event_type_id", "package_id"], name: "index_packages_events_types_on_event_type_id_and_package_id", unique: true, using: :btree

  create_table "payments", force: :cascade do |t|
    t.string   "method"
    t.float    "price"
    t.datetime "update_at"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "event_id",   null: false
    t.integer  "buyer_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "purchases", ["event_id", "buyer_id"], name: "index_purchases_on_event_id_and_buyer_id", unique: true, using: :btree

  create_table "schedules", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
  end

  add_index "schedules", ["event_id"], name: "index_schedules_on_event_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",            null: false
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,             null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.integer  "semester"
    t.string   "course"
    t.string   "university"
    t.date     "birthday"
    t.boolean  "qualified"
    t.string   "cpf",                    default: "00000000000", null: false
    t.string   "rg",                     default: "00000000000", null: false
    t.string   "size",                   default: "M",           null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "schedules", "events"
end
