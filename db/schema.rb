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

ActiveRecord::Schema.define(version: 2024_05_22_171655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "title"
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id"], name: "index_bookmarks_on_exercise_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "calendar_users", force: :cascade do |t|
    t.string "calendar_type", null: false
    t.bigint "calendar_id", null: false
    t.string "user_type", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["calendar_type", "calendar_id"], name: "index_calendar_users_on_calendar"
    t.index ["user_type", "user_id"], name: "index_calendar_users_on_user"
  end

  create_table "calendars", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.string "color"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_calendars_on_user_id"
  end

  create_table "customizes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "line_user_id", null: false
    t.bigint "calendar_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["calendar_id"], name: "index_customizes_on_calendar_id"
    t.index ["line_user_id"], name: "index_customizes_on_line_user_id"
    t.index ["user_id"], name: "index_customizes_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "duration"
    t.integer "difficulty"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_users", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.string "name", null: false
    t.string "profile_image_url"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_user_id"], name: "index_line_users_on_line_user_id", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.bigint "exercise_id", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "repetitions"
    t.integer "duration"
    t.index ["calendar_id"], name: "index_schedules_on_calendar_id"
    t.index ["exercise_id"], name: "index_schedules_on_exercise_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "exercises", on_delete: :cascade
  add_foreign_key "bookmarks", "users", on_delete: :cascade
  add_foreign_key "calendars", "users"
  add_foreign_key "customizes", "calendars"
  add_foreign_key "customizes", "line_users"
  add_foreign_key "customizes", "users"
  add_foreign_key "schedules", "calendars"
  add_foreign_key "schedules", "exercises"
end
