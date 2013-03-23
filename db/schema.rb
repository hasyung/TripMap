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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130321070011) do

  create_table "activate_maps", :force => true do |t|
    t.integer  "map_id",               :null => false
    t.integer  "map_serial_number_id", :null => false
    t.string   "device_id",            :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "audios", :force => true do |t|
    t.integer  "audioable_id"
    t.string   "audioable_type"
    t.string   "file",                          :null => false
    t.string   "file_type"
    t.integer  "file_size",      :default => 0
    t.integer  "order",          :default => 0
    t.integer  "duration",       :default => 0
    t.integer  "audio_type",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "image_lists", :force => true do |t|
    t.integer  "recommend_detailed_id",                :null => false
    t.string   "name",                                 :null => false
    t.integer  "order",                 :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "file",                          :null => false
    t.string   "file_type"
    t.integer  "file_size",      :default => 0
    t.integer  "order",          :default => 0
    t.integer  "height",         :default => 0
    t.integer  "width",          :default => 0
    t.integer  "image_type",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "infos", :force => true do |t|
    t.integer  "map_id",                                  :null => false
    t.string   "name",       :limit => 20,                :null => false
    t.string   "slug",       :limit => 20,                :null => false
    t.integer  "order",                    :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "logs", :force => true do |t|
    t.integer  "map_id",                                       :null => false
    t.integer  "activate_map_id",                              :null => false
    t.integer  "device_type_cd",                :default => 0
    t.string   "slug",            :limit => 20,                :null => false
    t.integer  "message_cd",                    :default => 0
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "map_serial_numbers", :force => true do |t|
    t.integer  "map_id",                    :null => false
    t.string   "code",                      :null => false
    t.integer  "type_cd",    :default => 0
    t.integer  "used",       :default => 0
    t.integer  "printed_cd", :default => 0
    t.integer  "count",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "map_serial_numbers", ["code"], :name => "index_map_serial_numbers_on_code", :unique => true

  create_table "maps", :force => true do |t|
    t.integer  "province_id",                                   :null => false
    t.string   "name",             :limit => 20,                :null => false
    t.string   "slug",             :limit => 20
    t.string   "version",          :limit => 30
    t.integer  "scenics_count",                  :default => 0
    t.integer  "places_count",                   :default => 0
    t.integer  "recommends_count",               :default => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "shares_count",                   :default => 0
    t.integer  "infos_count",                    :default => 0
  end

  add_index "maps", ["name"], :name => "index_maps_on_name", :unique => true
  add_index "maps", ["slug"], :name => "index_maps_on_slug", :unique => true

  create_table "places", :force => true do |t|
    t.integer  "map_id",                   :null => false
    t.string   "name",       :limit => 20, :null => false
    t.string   "slug",       :limit => 20, :null => false
    t.string   "subtitle",   :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "places", ["name"], :name => "index_places_on_name", :unique => true
  add_index "places", ["slug"], :name => "index_places_on_slug", :unique => true

  create_table "provinces", :force => true do |t|
    t.string   "name",       :limit => 20,                :null => false
    t.string   "slug",       :limit => 20,                :null => false
    t.integer  "maps_count",               :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "provinces", ["name"], :name => "index_provinces_on_name", :unique => true
  add_index "provinces", ["slug"], :name => "index_provinces_on_slug", :unique => true

  create_table "recommend_detaileds", :force => true do |t|
    t.integer  "recommend_record_id"
    t.string   "name"
    t.integer  "order",               :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "recommend_records", :force => true do |t|
    t.integer  "recommend_id",                             :null => false
    t.string   "name",                                     :null => false
    t.integer  "order",                     :default => 0
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "recommend_detaileds_count", :default => 0
  end

  create_table "recommends", :force => true do |t|
    t.integer  "map_id",                                               :null => false
    t.string   "name",                    :limit => 20,                :null => false
    t.string   "slug",                    :limit => 20,                :null => false
    t.integer  "recommend_records_count",               :default => 0
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "recommends", ["name"], :name => "index_recommends_on_name", :unique => true
  add_index "recommends", ["slug"], :name => "index_recommends_on_slug", :unique => true

  create_table "scenics", :force => true do |t|
    t.integer  "map_id",                   :null => false
    t.string   "name",       :limit => 20, :null => false
    t.string   "slug",       :limit => 20, :null => false
    t.string   "subtitle",   :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "scenics", ["name"], :name => "index_scenics_on_name", :unique => true
  add_index "scenics", ["slug"], :name => "index_scenics_on_slug", :unique => true

  create_table "shares", :force => true do |t|
    t.integer  "map_id",                                  :null => false
    t.string   "nickname",   :limit => 30
    t.string   "title",      :limit => 20,                :null => false
    t.integer  "state_cd",                 :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "texts", :force => true do |t|
    t.integer  "textable_id"
    t.string   "textable_type"
    t.text     "body",                         :null => false
    t.integer  "order",         :default => 0
    t.integer  "text_type",     :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.string   "file",                          :null => false
    t.string   "file_type"
    t.integer  "file_size",      :default => 0
    t.string   "cover",                         :null => false
    t.string   "cover_type"
    t.integer  "cover_size",     :default => 0
    t.integer  "order",          :default => 0
    t.integer  "duration",       :default => 0
    t.integer  "video_type",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
