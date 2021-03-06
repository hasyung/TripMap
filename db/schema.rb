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

ActiveRecord::Schema.define(:version => 20130627064550) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nickname",               :limit => 30
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true

  create_table "activate_maps", :force => true do |t|
    t.string   "device_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "activate_maps", ["device_id"], :name => "index_activate_maps_on_device_id", :unique => true

  create_table "activate_with_accounts", :force => true do |t|
    t.integer  "activate_map_id", :null => false
    t.integer  "account_id",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "activate_with_accounts", ["activate_map_id", "account_id"], :name => "index_activate_with_accounts_on_activate_map_id_and_account_id", :unique => true

  create_table "audio_list_categories", :force => true do |t|
    t.integer  "map_id",                        :null => false
    t.string   "name",                          :null => false
    t.string   "menu_type"
    t.boolean  "is_free",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "audio_list_categories", ["name"], :name => "index_audio_list_categories_on_name", :unique => true

  create_table "audio_list_items", :force => true do |t|
    t.integer  "audio_list_id",                :null => false
    t.string   "title",                        :null => false
    t.string   "abstract",                     :null => false
    t.integer  "order",         :default => 0, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "audio_list_items", ["audio_list_id", "title", "order"], :name => "index_audio_list_items_on_audio_list_id_and_title_and_order", :unique => true

  create_table "audio_lists", :force => true do |t|
    t.integer  "audio_list_category_id",                :null => false
    t.string   "name",                                  :null => false
    t.string   "abstract",                              :null => false
    t.integer  "order",                  :default => 0, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "audio_lists", ["audio_list_category_id", "name", "order"], :name => "index_audio_lists_on_audio_list_category_id_and_name_and_order", :unique => true

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

  add_index "audios", ["audioable_id", "audioable_type", "order", "audio_type"], :name => "aaoa_index", :unique => true

  create_table "broadcasts", :force => true do |t|
    t.integer  "map_id",                        :null => false
    t.string   "name",                          :null => false
    t.string   "menu_type"
    t.boolean  "is_free",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "children_broadcasts", :force => true do |t|
    t.integer  "broadcast_id"
    t.string   "name",         :null => false
    t.integer  "order",        :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "children_broadcasts", ["name"], :name => "index_children_broadcasts_on_name", :unique => true

  create_table "cities", :force => true do |t|
    t.string   "name",           :limit => 20,                :null => false
    t.string   "slug",           :limit => 20,                :null => false
    t.integer  "counties_count",               :default => 0
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "cities", ["name"], :name => "index_cities_on_name", :unique => true
  add_index "cities", ["slug"], :name => "index_cities_on_slug", :unique => true

  create_table "counties", :force => true do |t|
    t.integer  "city_id",                                      :null => false
    t.string   "name",            :limit => 20,                :null => false
    t.string   "slug",            :limit => 20,                :null => false
    t.integer  "merchants_count",               :default => 0
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "counties", ["name"], :name => "index_counties_on_name", :unique => true
  add_index "counties", ["slug"], :name => "index_counties_on_slug", :unique => true

  create_table "declarations", :force => true do |t|
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "device_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "devices", ["device_id"], :name => "index_devices_on_device_id", :unique => true

  create_table "devices_map_serial_numbers", :force => true do |t|
    t.integer  "map_serial_number_id", :null => false
    t.integer  "device_id",            :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "downloads", :force => true do |t|
    t.integer  "count"
    t.integer  "type",       :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "account_id"
    t.string   "body",       :limit => 1000, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "fights", :force => true do |t|
    t.integer  "county_id",                :null => false
    t.string   "name",       :limit => 20, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "fights", ["name"], :name => "index_fights_on_name", :unique => true

  create_table "first_known_list_items", :force => true do |t|
    t.integer  "first_known_list_id",                :null => false
    t.integer  "order",               :default => 0, :null => false
    t.string   "title",                              :null => false
    t.string   "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "first_known_list_items", ["first_known_list_id", "title"], :name => "index_first_known_list_items_on_first_known_list_id_and_title", :unique => true

  create_table "first_known_lists", :force => true do |t|
    t.integer  "first_known_id",                :null => false
    t.string   "title_cn",                      :null => false
    t.string   "title_en",                      :null => false
    t.string   "abstract"
    t.string   "url"
    t.integer  "order",          :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "first_knowns", :force => true do |t|
    t.integer  "map_id",                        :null => false
    t.string   "name",                          :null => false
    t.string   "menu_type"
    t.boolean  "is_free",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "first_knowns", ["map_id", "name"], :name => "index_first_knowns_on_map_id_and_name", :unique => true

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
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "images", ["imageable_id", "imageable_type", "order", "image_type"], :name => "iioi_index", :unique => true

  create_table "info_lists", :force => true do |t|
    t.integer  "map_id",                                       :null => false
    t.string   "name",        :limit => 20,                    :null => false
    t.integer  "order",                     :default => 0
    t.boolean  "is_free",                   :default => false
    t.integer  "infos_count",               :default => 0
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "info_lists", ["map_id", "order"], :name => "index_info_lists_on_map_id_and_order", :unique => true
  add_index "info_lists", ["name"], :name => "index_info_lists_on_name", :unique => true

  create_table "infos", :force => true do |t|
    t.integer  "info_list_id",                                  :null => false
    t.string   "name",         :limit => 20,                    :null => false
    t.integer  "order",                      :default => 0
    t.boolean  "is_free",                    :default => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "infos", ["info_list_id", "order"], :name => "index_infos_on_info_list_id_and_order", :unique => true
  add_index "infos", ["name"], :name => "index_infos_on_name", :unique => true

  create_table "ip_addresses", :force => true do |t|
    t.string   "ip",                        :null => false
    t.integer  "counter",    :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "keywords", :force => true do |t|
    t.integer  "keywordable_id"
    t.string   "keywordable_type"
    t.integer  "keyword_type",                   :default => 0
    t.string   "slug",             :limit => 20,                :null => false
    t.string   "version"
    t.string   "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["slug"], :name => "index_keywords_on_slug", :unique => true

  create_table "lijiang_mailboxes", :force => true do |t|
    t.string   "device_id",                    :null => false
    t.integer  "service_score", :default => 0
    t.integer  "env_score",     :default => 0
    t.integer  "category",      :default => 0
    t.string   "title"
    t.string   "content"
    t.string   "who"
    t.string   "contact"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "logs", :force => true do |t|
    t.integer  "map_id",                                       :null => false
    t.integer  "activate_map_id",                              :null => false
    t.string   "device_id"
    t.integer  "device_type_cd",                :default => 0
    t.string   "slug",            :limit => 20,                :null => false
    t.integer  "message_cd",                    :default => 0
    t.string   "info"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "map_serial_numbers", :force => true do |t|
    t.integer  "map_id",                     :null => false
    t.string   "code",                       :null => false
    t.integer  "type_cd",     :default => 0
    t.integer  "used",        :default => 0
    t.integer  "activate_cd", :default => 0
    t.integer  "count",       :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "account_id"
  end

  add_index "map_serial_numbers", ["code"], :name => "index_map_serial_numbers_on_code", :unique => true

  create_table "maps", :force => true do |t|
    t.integer  "province_id",                                   :null => false
    t.string   "name",             :limit => 20,                :null => false
    t.string   "version",          :limit => 30
    t.integer  "scenics_count",                  :default => 0
    t.integer  "places_count",                   :default => 0
    t.integer  "recommends_count",               :default => 0
    t.integer  "info_lists_count",               :default => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "shares_count",                   :default => 0
  end

  add_index "maps", ["name"], :name => "index_maps_on_name", :unique => true

  create_table "merchants", :force => true do |t|
    t.integer  "county_id",                                :null => false
    t.string   "title",       :limit => 20,                :null => false
    t.string   "name",        :limit => 50,                :null => false
    t.string   "tag",         :limit => 50
    t.integer  "type_cd",                   :default => 0
    t.string   "address",     :limit => 50,                :null => false
    t.string   "phone",       :limit => 12,                :null => false
    t.string   "shop_hour",   :limit => 20
    t.string   "expence",     :limit => 20
    t.string   "privilege"
    t.string   "special"
    t.text     "description"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "merchants", ["name"], :name => "index_merchants_on_name", :unique => true

  create_table "minorities", :force => true do |t|
    t.string   "name",              :limit => 20,                    :null => false
    t.integer  "order",                           :default => 0
    t.boolean  "is_free",                         :default => false
    t.string   "menu_type"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "minorityable_id"
    t.string   "minorityable_type"
  end

  add_index "minorities", ["name"], :name => "index_minorities_on_name", :unique => true

  create_table "minority_feels", :force => true do |t|
    t.integer  "minority_id",                              :null => false
    t.string   "name",        :limit => 20,                :null => false
    t.integer  "order",                     :default => 0
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "minority_slides", :force => true do |t|
    t.integer  "minority_id",                :null => false
    t.integer  "order",       :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "panel_videos", :force => true do |t|
    t.integer  "map_id",     :null => false
    t.string   "name",       :null => false
    t.string   "video",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "places", :force => true do |t|
    t.integer  "map_id",                                      :null => false
    t.string   "name",       :limit => 20,                    :null => false
    t.string   "subtitle",   :limit => 30
    t.boolean  "is_free",                  :default => false
    t.string   "menu_type"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

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
    t.integer  "map_id",                                                   :null => false
    t.string   "name",                    :limit => 20,                    :null => false
    t.integer  "recommend_records_count",               :default => 0
    t.boolean  "is_free",                               :default => false
    t.string   "menu_type"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "category_cd",                           :default => 1
  end

  add_index "recommends", ["name"], :name => "index_recommends_on_name", :unique => true

  create_table "scenics", :force => true do |t|
    t.integer  "map_id",                                      :null => false
    t.string   "name",       :limit => 20,                    :null => false
    t.string   "subtitle",   :limit => 30
    t.boolean  "is_free",                  :default => false
    t.string   "menu_type"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "shares", :force => true do |t|
    t.integer  "map_id",                                  :null => false
    t.integer  "account_id",                              :null => false
    t.string   "title",      :limit => 20,                :null => false
    t.integer  "state_cd",                 :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "specials", :force => true do |t|
    t.integer  "map_id",                                      :null => false
    t.string   "name",       :limit => 20,                    :null => false
    t.boolean  "is_free",                  :default => false
    t.string   "menu_type"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "specials", ["name"], :name => "index_specials_on_name", :unique => true

  create_table "surround_cities", :force => true do |t|
    t.integer  "map_id",                  :null => false
    t.string   "city_name",  :limit => 5, :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "surround_cities", ["city_name"], :name => "index_surround_cities_on_city_name", :unique => true

  create_table "texts", :force => true do |t|
    t.integer  "textable_id"
    t.string   "textable_type"
    t.text     "body",                         :null => false
    t.integer  "order",         :default => 0
    t.integer  "text_type",     :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "texts", ["textable_id", "textable_type", "order", "text_type"], :name => "ttot_index", :unique => true

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

  create_table "versions", :force => true do |t|
    t.integer  "platform",    :default => 0
    t.string   "value",                      :null => false
    t.string   "description"
    t.string   "app"
    t.string   "url"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "versions", ["platform", "value"], :name => "index_versions_on_platform_and_value", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.string   "file"
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

  add_index "videos", ["videoable_id", "videoable_type", "order", "video_type"], :name => "vvov_index", :unique => true

  create_table "weathers", :force => true do |t|
    t.string   "weatherable_type"
    t.integer  "weatherable_id"
    t.string   "tmp_current"
    t.string   "tmp_today"
    t.string   "tmp_desc"
    t.string   "tmp_wind"
    t.string   "tmp_pic_from"
    t.string   "tmp_pic_to"
    t.string   "tmp_humidity"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
