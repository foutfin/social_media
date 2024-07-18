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

ActiveRecord::Schema.define(version: 2024_07_18_120722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: :cascade do |t|
    t.bigint "follow_by_id", null: false
    t.bigint "follow_to_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follow_by_id"], name: "index_connections_on_follow_by_id"
    t.index ["follow_to_id"], name: "index_connections_on_follow_to_id"
  end

  create_table "follow_requests", force: :cascade do |t|
    t.bigint "from_id", null: false
    t.bigint "to_id", null: false
    t.boolean "approved"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id"], name: "index_follow_requests_on_from_id"
    t.index ["to_id"], name: "index_follow_requests_on_to_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "caption"
    t.text "body"
    t.boolean "archived", default: false
    t.integer "likes", default: 0
    t.integer "dislikes", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "title"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_resources_on_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  add_foreign_key "connections", "users", column: "follow_by_id"
  add_foreign_key "connections", "users", column: "follow_to_id"
  add_foreign_key "follow_requests", "users", column: "from_id"
  add_foreign_key "follow_requests", "users", column: "to_id"
  add_foreign_key "posts", "users"
  add_foreign_key "resources", "posts"
end
