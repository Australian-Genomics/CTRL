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

ActiveRecord::Schema.define(version: 2018_04_16_122836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "questions", force: :cascade do |t|
    t.integer "number"
    t.boolean "answer"
    t.bigint "steps_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["steps_id"], name: "index_questions_on_steps_id"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "number"
    t.boolean "accepted"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_steps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "family_name"
    t.string "phone_no"
    t.date "dob"
    t.string "preferred_contact_method", default: "Email"
    t.string "address"
    t.string "suburb"
    t.string "state"
    t.string "post_code"
    t.integer "flagship"
    t.boolean "is_parent", default: false
    t.string "kin_first_name"
    t.string "kin_middle_name"
    t.string "kin_family_name"
    t.string "kin_contact_no"
    t.string "kin_email"
    t.string "study_id"
    t.string "child_first_name"
    t.string "child_middle_name"
    t.string "child_family_name"
    t.date "child_dob"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
