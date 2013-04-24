class Place < ActiveRecord::Base

  # White list
  attr_accessible :map, :map_id, :name, :slug, :subtitle, :is_free,
                  :place_icon_attributes, :place_image_attributes, :place_description_image_attributes,
                  :place_video_attributes, :place_audio_attributes, :place_description_attributes

  # Associations
  with_options :dependent => :destroy do |assoc|
    assoc.has_one :place_audio, :as => :audioable, :class_name => "Audio", :conditions => { :audio_type => Audio.place_audio }
    assoc.has_one :place_video, :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.place_video }
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one :place_icon,              :conditions => { :image_type => Image.place_icon }
    assoc.has_one :place_description_image, :conditions => { :image_type => Image.place_description_image }
    assoc.has_one :place_image,             :conditions => { :image_type => Image.place_image }
    assoc.has_many :place_slides,  :conditions => { :image_type => Image.place_slides  }
  end

  has_one :place_description, :as => :textable, :class_name => "Letter", :conditions => { :text_type => Letter.place_description }, :dependent => :destroy

  belongs_to :map, :counter_cache => true

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }
    column.validates :map_id
    column.validates :slug, :length => { :within => 2..20 }, :format => { :with => /^[a-z]+$/, :message => I18n.t("errors.type.slug") }
    column.validates :subtitle, :length => { :within => 2..30 }
  end

  # NestedAttributes
  accepts_nested_attributes_for :place_icon,              reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_description_image, reject_if: lambda { |d| d[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_image,             reject_if: lambda { |img| img[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_audio,             reject_if: lambda { |pa| pa[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_video,             reject_if: lambda { |pv| pv[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :place_description, allow_destroy: true

  scope :created_desc, order("`created_at` DESC")

end