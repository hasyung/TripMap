class Map < ActiveRecord::Base

  #White list
  attr_accessible :province, :province_id, :name, :slug,
                  :map_description_attributes, :map_cover_attributes; :map_plat_attributes

  # Associations
  with_options :dependent => :destroy do |assoc|
    assoc.has_many :scenics, :autosave => true
    assoc.has_many :places, :autosave => true
    assoc.has_many :recommends, :autosave => true
    assoc.has_many :shares, :autosave => true
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :map_cover,   :conditions => { :image_type => Image.map_cover   }
    assoc.has_one  :map_plat,    :conditions => { :image_type => Image.map_plat    }
    assoc.has_many :map_slides,  :conditions => { :image_type => Image.map_slides  }
  end

  has_one :map_description, :as => :textable, :class_name => 'Text', 
          :conditions => { :text_type => Text.map_description },
          :dependent => :destroy
  
  belongs_to :province, :counter_cache => true

  # Validates
  with_options :presence=> true do |column|
    column.validates :province_id
    column.validates :name, :length => { :within => 1..15,    :message => I18n.t("errors.type.name") }
    column.validates :slug, :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }
  end
  
  #validate :require_map_cover_attributes
  
  # NestedAttributes
  accepts_nested_attributes_for :map_cover, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_plat, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_description, reject_if: lambda { |pd| pd[:body].blank? }, :allow_destroy => true
  
  # Scopes
  scope :created_desc, order("created_at DESC")
  
  # Methods
    
end
