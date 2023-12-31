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

ActiveRecord::Schema[7.0].define(version: 2023_09_25_090414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "trader_id", null: false
    t.bigint "stock_id", null: false
    t.integer "quantity"
    t.float "current_price"
    t.float "total_amount"
    t.string "stock_symbol"
    t.boolean "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_portfolios_on_stock_id"
    t.index ["trader_id"], name: "index_portfolios_on_trader_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "price_currency"
    t.float "price_amount"
    t.float "percent_change"
    t.integer "volume"
    t.datetime "as_of"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traders", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "status", default: "pending"
    t.datetime "confirmed_at"
    t.float "balance", default: 500.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "trader_id", null: false
    t.bigint "stock_id", null: false
    t.string "action"
    t.integer "quantity"
    t.float "total_price"
    t.string "stock_symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_transactions_on_stock_id"
    t.index ["trader_id"], name: "index_transactions_on_trader_id"
  end

  add_foreign_key "portfolios", "stocks"
  add_foreign_key "portfolios", "traders"
  add_foreign_key "transactions", "stocks"
  add_foreign_key "transactions", "traders"
end
