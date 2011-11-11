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

ActiveRecord::Schema.define(:version => 20111111205148) do

  create_table "courses", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "hashed_password"
    t.string "options"
  end

  add_index "courses", ["name"], :name => "index_courses_on_name"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "device_connections", :force => true do |t|
    t.integer "puerto_id"
    t.integer "endpoint_id"
  end

  create_table "dispositivos", :force => true do |t|
    t.string "nombre"
    t.string "etiqueta"
    t.string "tipo"
    t.string "categoria"
    t.string "estado"
    t.string "com"
  end

  create_table "dispositivos_practicas", :id => false, :force => true do |t|
    t.integer "dispositivo_id"
    t.integer "practica_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "eventable_id"
    t.string   "eventable_type"
  end

  create_table "practicas", :force => true do |t|
    t.string   "name"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "practicas_users", :id => false, :force => true do |t|
    t.integer "practica_id"
    t.integer "user_id"
  end

  create_table "profiles", :force => true do |t|
    t.string  "firstname"
    t.string  "lastname"
    t.string  "codigo"
    t.integer "user_id"
  end

  add_index "profiles", ["codigo"], :name => "index_profiles_on_codigo"

  create_table "puertos", :force => true do |t|
    t.string  "nombre"
    t.string  "etiqueta"
    t.string  "estado"
    t.integer "dispositivo_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "username",                                            :null => false
    t.string   "type",                                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "options"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "users_courses", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  create_table "vlans", :force => true do |t|
    t.integer  "numero"
    t.integer  "practica_id"
    t.integer  "puerto_id"
    t.integer  "endpoint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
