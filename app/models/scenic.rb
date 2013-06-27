class Scenic < ActiveRecord::Base

  attr_accessor :slug
  # White list
  attr_accessible :map, :map_id, :name, :subtitle, :is_free, :menu_type,
                  :slug, :scenic_impression_attributes,
                  :scenic_route_attributes, :scenic_icon_attributes, :scenic_slug_icon_attributes,
                  :scenic_image_attributes, :scenic_description_attributes, :scenic_description_image_attributes,
                  :scenic_slides_attributes, :scenic_slides_cover_attributes

  # Associations
  belongs_to :map, :counter_cache => true

  with_options :as => :textable, :class_name => "Letter", :dependent => :destroy do |assoc|
    assoc.has_one :scenic_description,        :conditions => { :text_type => Letter.scenic_description }
  end

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do |assoc|
    assoc.has_many :scenic_slugs,               :conditions => { :keyword_type => Keyword.scenic_slugs }
  end

  with_options :as => :videoable, :class_name => "Video", :dependent => :destroy do |assoc|
    assoc.has_one :scenic_impression,         :conditions => { :video_type => Video.scenic_impression }
    assoc.has_one :scenic_route,              :conditions => { :video_type => Video.scenic_route }
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do |assoc|
    assoc.has_one  :scenic_icon,              :conditions => { :image_type => Image.scenic_icon }
    assoc.has_one  :scenic_slug_icon,         :conditions => { :image_type => Image.scenic_slug_icon }
    assoc.has_one  :scenic_description_image, :conditions => { :image_type => Image.scenic_description_image }
    assoc.has_one  :scenic_image,             :conditions => { :image_type => Image.scenic_image }
    assoc.has_one  :scenic_slides_cover,      :conditions => { :image_type => Image.scenic_slides_cover }
    assoc.has_many :scenic_slides,            :conditions => { :image_type => Image.scenic_slides }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }
    column.validates :map_id
    column.validates :subtitle, :length => { :within => 2..30 }
  end

  # Nested attributes validates
  accepts_nested_attributes_for :scenic_impression,        reject_if: ->(attr){ (attr[:file].blank? && attr[:id].blank?) }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_route,             reject_if: ->(attr){ (attr[:file].blank? && attr[:id].blank?) }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_icon,              reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_slug_icon,         reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_image,             reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_description_image, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_slides_cover,      reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :scenic_description,                                                  :allow_destroy => true

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end