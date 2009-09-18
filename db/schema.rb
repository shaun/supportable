# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090917141502) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "url_name"
    t.string   "drop_name"
    t.string   "drop_token"
    t.string   "chat_password"
    t.string   "support_bot_nick"
    t.string   "support_bot_error_response"
    t.text     "landing_page_welcome_text"
    t.string   "homepage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_visits", :force => true do |t|
    t.integer  "company_id"
    t.string   "status"
    t.datetime "needed_help_at"
    t.datetime "help_arrived_at"
    t.datetime "problem_solved_at"
    t.string   "drop_name"
    t.string   "drop_token"
    t.string   "chat_password"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.integer  "company_id"
    t.string   "employee_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_actions", :force => true do |t|
    t.text     "description"
    t.string   "action_type"
    t.integer  "company_id"
    t.boolean  "root"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_options", :force => true do |t|
    t.integer  "parent_support_action_id"
    t.string   "control"
    t.text     "description"
    t.integer  "target_support_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
