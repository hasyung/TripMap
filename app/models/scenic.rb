class Scenic < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_one :icon,              :as => :imageable
  has_one :description,       :as => :textable
  has_one :description_image, :as => :imageable
  has_one :image,             :as => :imageable
  has_one :impression,        :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.impression }, :dependent => :destroy
  has_one :route,             :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.route }, :dependent => :destroy
  
  belongs_to :map, :counter_cache => true
  
  # Validates
  validates :name, :slug, :presence => true
end
