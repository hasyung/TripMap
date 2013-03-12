class Recommend < ActiveRecord::Base
  # White list
  attr_accessible :map, :map_id, :name, :slug

  # Associations
  has_one :recommend_video, :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.recommend_video }, :dependent => :destroy
          
  has_one :recommend_cover, :as => :imageable, :class_name => "Image", :conditions => { :image_type => Image.recommend_cover }, :dependent => :destroy

  has_many :recommend_records, :dependent => :destroy

  belongs_to :map, :counter_cache => true

end
