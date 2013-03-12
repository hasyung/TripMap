class Scenic < ActiveRecord::Base

  attr_accessible :map, :map_id, :name, :slug
  
  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }
    column.validates :slug, :format => { :with => /([a-z]|[A-Z])+/ }
  end
  
  with_options :as => :videoable, :class_name => "Video", :dependent => :destroy do |assoc|
    assoc.has_one :scenic_impression, :conditions => { :video_type => Video.scenic_impression }
    assoc.has_one :scenic_route,      :conditions => { :video_type => Video.scenic_route }
  end
  
  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do |assoc|
    assoc.has_one :scenic_icon,               :conditions => { :image_type => Image.scenic_icon}
    assoc.has_one :scenic_description_image,  :conditions => { :image_type => Image.scenic_description_image }
    assoc.has_one :scenic_image,              :conditions => { :image_type => Image.scenic_image }
  end
  
  has_one :scenic_description, :as => :textable, :class_name => "Text", :conditions => { :text_type => Text.scenic_description }
  
  belongs_to :map, :counter_cache => true
end
