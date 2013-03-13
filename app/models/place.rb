class Place < ActiveRecord::Base
  
  # White list
  attr_accessible :map, :map_id, :name, :slug
  
  # Associations
  has_one :place_audio, :as => :audioable, :class_name => "Audio", :conditions => { :audio_type => Audio.place_audio }, :dependent => :destroy
  has_one :place_video, :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.place_video }, :dependent => :destroy
  
  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one :place_icon,              :conditions => { :image_type => Image.place_icon }
    assoc.has_one :place_description_image, :conditions => { :image_type => Image.place_description_image }
    assoc.has_one :place_image,             :conditions => { :image_type => Image.place_image }
  end
  
  has_one :place_description, :as => :textable, :class_name => "Text", :conditions => { :Text_type => Text.place_description }, :dependent => :destroy
  
  belongs_to :map, :counter_cache => true
  
  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }
    column.validates :slug, :format => { :with => /([a-z]|[A-Z]|)+/ }
  end
  
end