class Scenic < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :map_id, :name, :slug, :temp_icon, :temp
  
  has_many :videos,           :as => :videoable
  has_many :texts,       :as => :textable
  has_many :images,             :as => :imageable
  
  belongs_to :map, :counter_cache => true
end
