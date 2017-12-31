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

ActiveRecord::Schema.define(version: 20171231041330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "houses", force: :cascade do |t|
    t.integer "square_footage", null: false
    t.string "appliances"
    t.string "interior_features"
    t.string "basement_type"
    t.integer "garage_space"
    t.string "cooling"
    t.string "heating"
    t.string "foundation"
    t.integer "year_built"
    t.bigint "lot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_houses_on_lot_id"
  end

  create_table "lots", force: :cascade do |t|
    t.string "sub_type"
    t.string "address"
    t.string "zip"
    t.string "city"
    t.string "state"
    t.string "directions"
    t.decimal "list_price"
    t.decimal "original_list_price"
    t.integer "square_footage"
    t.string "lot_features"
    t.string "water_source"
    t.string "electric_provider"
    t.string "gas_provider"
    t.integer "tax_amount"
    t.integer "tax_year"
    t.string "disclaimer"
    t.integer "picture_count"
    t.boolean "publish_to_internet", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "category", null: false
    t.integer "width", null: false
    t.integer "length", null: false
    t.bigint "house_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_rooms_on_house_id"
  end

  add_foreign_key "houses", "lots"
  add_foreign_key "rooms", "houses"
end
