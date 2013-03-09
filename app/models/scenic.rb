class Scenic < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :map_id, :name, :slug, :temp_icon, :temp
  has_one :icon,              :as => :imageable
  has_many :videos,           :as => :videoable
  has_one :description,       :as => :textable
  has_one :description_image, :as => :imageable
  has_one :image,             :as => :imageable
  
  belongs_to :map, :counter_cache => true
end
