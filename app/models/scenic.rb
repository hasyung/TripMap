class Scenic < ActiveRecord::Base

  # White list
  attr_accessible :map, :map_id, :name, :slug, :scenic_impression_attributes, 
                  :scenic_route_attributes, :scenic_icon_attributes, :scenic_image_attributes, 
                  :scenic_description_attributes, :scenic_description_image_attributes
  
  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }, :uniqueness => true
    column.validates :slug, :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }, :uniqueness => true
    column.validates :map_id
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
  
  has_one :scenic_description, :as => :textable, :class_name => "Letter",
          :conditions => { :text_type => Letter.scenic_description },
          :dependent => :destroy
  
  belongs_to :map, :counter_cache => true

  #NestedAttributes
  accepts_nested_attributes_for :scenic_impression,    reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :scenic_route,         reject_if: lambda { |r| r[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :scenic_icon,          reject_if: lambda { |icon| icon[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :scenic_image,         reject_if: lambda { |image| image[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :scenic_description,   reject_if: lambda { |d| d[:body].blank? }, allow_destroy: true
  accepts_nested_attributes_for :scenic_description_image,   reject_if: lambda { |di| di[:file].blank? }, allow_destroy: true
  
end
