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

ActiveRecord::Schema.define(version: 2022_01_05_111009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "number"
    t.integer "answer"
    t.bigint "step_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.bigint "user_id"
    t.index ["step_id"], name: "index_questions_on_step_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "number"
    t.boolean "accepted"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_steps_on_user_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.string "locale", default: "en"
    t.integer "order"
    t.integer "step"
    t.integer "question_id"
    t.text "question"
    t.text "description"
    t.string "default_value"
    t.string "redcap_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_survey_questions_on_locale"
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
    t.string "address"
    t.string "suburb"
    t.integer "state"
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
    t.string "red_cap_survey_one_link"
    t.string "red_cap_survey_one_return_code"
    t.integer "red_cap_survey_one_status"
    t.boolean "survey_one_email_sent", default: false
    t.boolean "survey_one_email_reminder_sent", default: false
    t.string "red_cap_survey_two_link"
    t.string "red_cap_survey_two_return_code"
    t.integer "red_cap_survey_two_status"
    t.boolean "survey_two_email_sent", default: false
    t.boolean "survey_two_email_reminder_sent", default: false
    t.date "red_cap_date_consent_signed"
    t.date "red_cap_date_of_result_disclosure"
    t.integer "preferred_contact_method", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
