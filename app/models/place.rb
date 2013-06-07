class Place < ActiveRecord::Base

  # White list
  attr_accessible :map, :map_id, :name, :subtitle, :is_free, :menu_type,
                  :place_icon_attributes, :place_slug_icon_attributes, :place_image_attributes,
                  :place_description_image_attributes, :place_video_attributes, :place_audio_attributes,
                  :place_description_attributes, :place_slug_attributes, :place_slides_attributes

  # Associations
  belongs_to :map, :counter_cache => true

  with_options :dependent => :destroy do |assoc|
    assoc.has_one :place_audio, :as => :audioable, :class_name => "Audio", :conditions => { :audio_type => Audio.place_audio }
    assoc.has_one :place_video, :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.place_video }
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one  :place_icon,               :conditions => { :image_type => Image.place_icon }
    assoc.has_one  :place_slug_icon,          :conditions => { :image_type => Image.place_slug_icon }
    assoc.has_one  :place_description_image,  :conditions => { :image_type => Image.place_description_image }
    assoc.has_one  :place_image,              :conditions => { :image_type => Image.place_image }
    assoc.has_many :place_slides,             :conditions => { :image_type => Image.place_slides }
  end

  with_options :as => :textable, :class_name => "Letter", :dependent => :destroy do|assoc|
    assoc.has_one  :place_description,        :conditions => { :text_type => Letter.place_description }
  end

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do|assoc|
    assoc.has_one :place_slug,                :conditions => { :keyword_type => Keyword.place_slug }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }
    column.validates :map_id
    column.validates :subtitle, :length => { :within => 2..30 }
  end

  # Nested attributes validates
  accepts_nested_attributes_for :place_icon,              reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_slug_icon,         reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_description_image, reject_if: lambda { |d| d[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_image,             reject_if: lambda { |img| img[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_audio,             reject_if: lambda { |pa| (pa[:file].blank? && pa[:id].blank?) }, allow_destroy: true
  accepts_nested_attributes_for :place_video,             reject_if: lambda { |pv| (pv[:file].blank? && pv[:id].blank?) }, allow_destroy: true
  accepts_nested_attributes_for :place_description,       allow_destroy: true
  accepts_nested_attributes_for :place_slug,              allow_destroy: true
  accepts_nested_attributes_for :place_slides,            allow_destroy: true

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end