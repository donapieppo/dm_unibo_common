ActiveRecord::Schema.define(version: 2020_02_13_095950) do

  create_table "organizations", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "upn", null: false
    t.string "name"
    t.string "surname"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.integer "user_id", unsigned: true
    t.string  "network"
    t.integer "authlevel"
  end

  create_table "things", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.integer "user_id", unsigned: true
    t.text "name"
  end

end

