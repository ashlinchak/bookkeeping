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

ActiveRecord::Schema.define(version: 20150706182800) do

  create_table "bookkeeping_accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.boolean  "overdraft_enabled", default: true, null: false
    t.integer  "accountable_id"
    t.string   "accountable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookkeeping_accounts", ["accountable_id"], name: "index_bookkeeping_accounts_on_accountable_id"
  add_index "bookkeeping_accounts", ["accountable_type"], name: "index_bookkeeping_accounts_on_accountable_type"

  create_table "bookkeeping_amounts", force: :cascade do |t|
    t.string  "type"
    t.boolean "is_debit",                            default: true, null: false
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount",     precision: 20, scale: 2, default: 0.0
  end

  add_index "bookkeeping_amounts", ["account_id"], name: "index_bookkeeping_amounts_on_account_id"
  add_index "bookkeeping_amounts", ["entry_id"], name: "index_bookkeeping_amounts_on_entry_id"

  create_table "bookkeeping_entries", force: :cascade do |t|
    t.string   "description"
    t.integer  "transactionable_id"
    t.string   "transactionable_type"
    t.integer  "rollback_entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookkeeping_entries", ["transactionable_id"], name: "index_bookkeeping_entries_on_transactionable_id"
  add_index "bookkeeping_entries", ["transactionable_type"], name: "index_bookkeeping_entries_on_transactionable_type"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
