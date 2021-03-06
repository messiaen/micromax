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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120129055222) do

  create_table "account_types", :force => true do |t|
    t.string   "name"
    t.string   "internal_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "min_balance"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "internal_name"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_profiles", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "profile_id"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people_accounts", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "account_id"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "person_id"
    t.boolean  "is_admin"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.date     "date"
    t.float    "amount"
    t.float    "account_balance"
    t.string   "description"
    t.integer  "category_id"
    t.integer  "account_id"
    t.integer  "person_id"
    t.integer  "child_id"
    t.integer  "parent_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["child_id"], :name => "index_transactions_on_child_id"
  add_index "transactions", ["date"], :name => "index_transactions_on_date"
  add_index "transactions", ["parent_id"], :name => "index_transactions_on_parent_id"

end
