ActiveRecord::Schema.define(:version => 20130309090229) do

  create_table "audios", :force => true do |t|
    t.integer  "audioable_id"
    t.string   "audioable_type"
    t.string   "file",                          :null => false
    t.string   "file_type"
    t.integer  "file_size",      :default => 0
    t.integer  "order",          :default => 0
    t.integer  "duration",       :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "image_lists", :force => true do |t|
    t.integer  "recommend_record_id", :null => false
    t.string   "name",                :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "file",                          :null => false
    t.string   "file_type"
    t.integer  "file_size",      :default => 0
    t.integer  "order",          :default => 0
    t.integer  "group_id",       :default => 0
    t.integer  "group_order",    :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "maps", :force => true do |t|
    t.integer  "province_id",                                   :null => false
    t.string   "name",             :limit => 20,                :null => false
    t.string   "slug",             :limit => 20,                :null => false
    t.integer  "scenics_count",                  :default => 0
    t.integer  "places_count",                   :default => 0
    t.integer  "recommends_count",               :default => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "places", :force => true do |t|
    t.integer  "map_id",                   :null => false
    t.string   "name",       :limit => 20, :null => false
    t.string   "slug",       :limit => 20, :null => false
    t.string   "temp_icon"
    t.string   "temp"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "name",       :limit => 20,                :null => false
    t.string   "slug",       :limit => 20,                :null => false
    t.integer  "maps_count",               :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "recommend_records", :force => true do |t|
    t.integer  "recommend_id",                :null => false
    t.string   "name",                        :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "order",        :default => 0
  end

  create_table "recommends", :force => true do |t|
    t.integer  "map_id",                                               :null => false
    t.string   "name",                    :limit => 20,                :null => false
    t.string   "slug",                    :limit => 20,                :null => false
    t.integer  "recommend_records_count",               :default => 0
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "scenics", :force => true do |t|
    t.integer  "map_id",                   :null => false
    t.string   "name",       :limit => 20, :null => false
    t.string   "slug",       :limit => 20, :null => false
    t.string   "temp_icon"
    t.string   "temp"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "texts", :force => true do |t|
    t.integer  "textable_id"
    t.string   "textable_type"
    t.text     "body",                         :null => false
    t.integer  "order",         :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

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
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
