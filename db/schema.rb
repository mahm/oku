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

ActiveRecord::Schema.define(version: 20150205031430) do

  create_table "auctions", force: true do |t|
    t.integer  "user_id",                       null: false
    t.datetime "open_at",                       null: false
    t.datetime "close_at",                      null: false
    t.integer  "first_price",   default: 0,     null: false
    t.integer  "highest_price", default: 0,     null: false
    t.boolean  "closed",        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "item_name"
    t.integer  "amount",        default: 1,     null: false
    t.integer "category_id"
  end

  add_index "auctions", ["category_id"], name: "index_auctions_on_category_id"
  add_index "auctions", ["user_id"], name: "index_auctions_on_user_id"

  create_table "bids", force: true do |t|
    t.integer  "auction_id", null: false
    t.integer  "user_id",    null: false
    t.integer  "price",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id"
  add_index "bids", ["user_id"], name: "index_bids_on_user_id"

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "code"
  end

  add_index "categories", ["code"], name: "index_categories_on_code", unique: true

  create_table "evaluations", force: true do |t|
    t.integer  "evaluater_id"
    t.integer  "evaluatee_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluations", ["evaluatee_id"], name: "index_evaluations_on_evaluatee_id"
  add_index "evaluations", ["evaluater_id", "evaluatee_id"], name: "index_evaluations_on_evaluater_id_and_evaluatee_id", unique: true
  add_index "evaluations", ["evaluater_id"], name: "index_evaluations_on_evaluater_id"

  create_table "items", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "category_id", null: false
    t.string   "name",        null: false
    t.text     "explanation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id"
  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname"
    t.text     "intoroduction"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
