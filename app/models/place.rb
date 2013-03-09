class Place < ActiveRecord::Base
  attr_accessible :map_id, :name, :slug, :temp_icon, :temp#, :icon, :video, :audio, :description, :description_image, :image

  has_many :videos,             :as => :videoable
  has_many :audios,             :as => :audioable
  has_many :images,             :as => :imageable
  
  belongs_to :map, :counter_cache => true
  
end
