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

ActiveRecord::Schema[7.0].define(version: 2023_06_06_001727) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_users", force: :cascade do |t|
    t.string "name"
    t.string "token_digest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_api_users_on_name", unique: true
  end

  create_table "conditional_duo_limitations", force: :cascade do |t|
    t.text "json"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "conditional_duo_limitations_consent_questions", id: false, force: :cascade do |t|
    t.bigint "conditional_duo_limitation_id", null: false
    t.bigint "consent_question_id", null: false
  end

  create_table "consent_groups", force: :cascade do |t|
    t.integer "order"
    t.bigint "consent_step_id"
    t.string "header"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["consent_step_id"], name: "index_consent_groups_on_consent_step_id"
    t.index ["order"], name: "index_consent_groups_on_order"
  end

  create_table "consent_questions", force: :cascade do |t|
    t.integer "order"
    t.bigint "consent_group_id"
    t.text "question"
    t.text "description"
    t.string "redcap_field"
    t.string "default_answer"
    t.string "question_type"
    t.string "answer_choices_position", default: "right"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_published", default: true
    t.string "redcap_event_name"
    t.index ["consent_group_id"], name: "index_consent_questions_on_consent_group_id"
    t.index ["order"], name: "index_consent_questions_on_order"
  end

  create_table "consent_steps", force: :cascade do |t|
    t.integer "order"
    t.string "title"
    t.text "description"
    t.text "popover"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "tour_videos"
    t.index ["order"], name: "index_consent_steps_on_order", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "glossary_entries", force: :cascade do |t|
    t.string "term", null: false
    t.text "definition", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "modal_fallbacks", force: :cascade do |t|
    t.text "description"
    t.string "cancel_btn"
    t.string "review_answers_btn"
    t.text "small_note"
    t.bigint "consent_step_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["consent_step_id"], name: "index_modal_fallbacks_on_consent_step_id"
  end

  create_table "participant_id_formats", force: :cascade do |t|
    t.string "participant_id_format"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "question_answers", force: :cascade do |t|
    t.integer "consent_question_id"
    t.integer "user_id"
    t.string "answer"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["consent_question_id"], name: "index_question_answers_on_consent_question_id"
    t.index ["user_id"], name: "index_question_answers_on_user_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.string "value"
    t.bigint "consent_question_id"
    t.string "color", default: "#02b0db"
    t.string "redcap_code"
    t.index ["consent_question_id"], name: "index_question_options_on_consent_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "number"
    t.integer "answer"
    t.bigint "step_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "question_id"
    t.bigint "user_id"
    t.index ["step_id"], name: "index_questions_on_step_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "step_reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "consent_step_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["consent_step_id"], name: "index_step_reviews_on_consent_step_id"
    t.index ["user_id"], name: "index_step_reviews_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.integer "number"
    t.boolean "accepted"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_steps_on_user_id"
  end

  create_table "survey_configs", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "key"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_file"
    t.string "hint"
  end

  create_table "user_column_to_redcap_field_mappings", force: :cascade do |t|
    t.string "user_column", null: false
    t.string "redcap_field", null: false
    t.string "redcap_event_name"
    t.index ["redcap_field", "redcap_event_name"], name: "uctrfm_redcap_index", unique: true
    t.index ["user_column"], name: "uctrfm_user_column_index", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "family_name"
    t.string "phone_no"
    t.date "dob"
    t.string "address"
    t.string "suburb"
    t.integer "state"
    t.string "post_code"
    t.boolean "is_parent", default: false
    t.string "kin_first_name"
    t.string "kin_middle_name"
    t.string "kin_family_name"
    t.string "kin_contact_no"
    t.string "kin_email"
    t.string "participant_id"
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
    t.index ["participant_id"], name: "index_users_on_participant_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "consent_groups", "consent_steps"
  add_foreign_key "consent_questions", "consent_groups"
  add_foreign_key "modal_fallbacks", "consent_steps"
  add_foreign_key "question_options", "consent_questions"
end
