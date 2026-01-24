# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_01_20_070707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "station_id", null: false
    t.index ["id"], name: "index_exits_on_id", unique: true
    t.index ["station_id"], name: "index_exits_on_station_id"
  end

  create_table "gates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "railway_company_id", null: false
    t.uuid "station_id", null: false
    t.index ["id"], name: "index_gates_on_id", unique: true
    t.index ["railway_company_id"], name: "index_gates_on_railway_company_id"
    t.index ["station_id"], name: "index_gates_on_station_id"
  end

  create_table "helpful_marks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_helpful_marks_on_route_id"
    t.index ["user_id", "route_id"], name: "index_helpful_marks_on_user_id_and_route_id", unique: true
    t.index ["user_id"], name: "index_helpful_marks_on_user_id"
  end

  create_table "railway_companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_railway_companies_on_id", unique: true
  end

  create_table "routes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "estimated_time"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.uuid "gate_id", null: false
    t.uuid "exit_id", null: false
    t.uuid "category_id"
    t.integer "helpful_marks_count", default: 0, null: false
    t.jsonb "images"
    t.index ["category_id"], name: "index_routes_on_category_id"
    t.index ["exit_id"], name: "index_routes_on_exit_id"
    t.index ["gate_id"], name: "index_routes_on_gate_id"
    t.index ["id"], name: "index_routes_on_id", unique: true
    t.index ["user_id"], name: "index_routes_on_user_id"
  end

  create_table "stations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_stations_on_id", unique: true
  end

  create_table "taggings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tag_id", null: false
    t.uuid "route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_taggings_on_route_id"
    t.index ["tag_id", "route_id"], name: "index_taggings_on_tag_id_and_route_id", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["guest"], name: "index_users_on_guest"
    t.index ["id"], name: "index_users_on_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "exits", "stations"
  add_foreign_key "gates", "railway_companies"
  add_foreign_key "gates", "stations"
  add_foreign_key "helpful_marks", "routes"
  add_foreign_key "helpful_marks", "users"
  add_foreign_key "routes", "categories"
  add_foreign_key "routes", "exits"
  add_foreign_key "routes", "gates"
  add_foreign_key "routes", "users"
  add_foreign_key "taggings", "routes"
  add_foreign_key "taggings", "tags"
end
