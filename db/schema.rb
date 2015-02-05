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

ActiveRecord::Schema.define(version: 20150205074838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.integer  "asset_class_id",                         null: false
    t.integer  "portfolio_id",                           null: false
    t.decimal  "weight",         precision: 3, scale: 2, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "allocations", ["portfolio_id", "asset_class_id"], name: "index_allocations_on_portfolio_id_and_asset_class_id", unique: true, using: :btree

  create_table "asset_classes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", force: :cascade do |t|
    t.integer  "asset_class_id",                           null: false
    t.string   "name",                                     null: false
    t.string   "symbol",                                   null: false
    t.decimal  "expense_ratio",    precision: 4, scale: 4, null: false
    t.money    "price",                          scale: 2, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "price_updated_at"
  end

  create_table "lots", force: :cascade do |t|
    t.integer  "fund_id"
    t.integer  "portfolio_id"
    t.datetime "acquired_at"
    t.datetime "sold_at"
    t.money    "proceeds",                    scale: 2
    t.decimal  "quantity",     precision: 15, scale: 6
    t.money    "share_cost",                  scale: 2
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "allocations", "asset_classes", on_delete: :restrict
  add_foreign_key "allocations", "portfolios", on_delete: :restrict
  add_foreign_key "funds", "asset_classes", on_delete: :restrict
end
