class Place < ActiveRecord::Base
  
  attr_accessible :name, :slug
  
  # Associations
  has_one :icon,              :as => :imageable
  has_one :video,             :as => :videoable
  has_one :audio,             :as => :audioable
  has_one :description,       :as => :textable
  has_one :description_image, :as => :imageable
  has_one :image,             :as => :imageable
  
  belongs_to :map, :counter_cache => true
  
  # Validates
  validates :name, :slug, :presence => true
  
end
