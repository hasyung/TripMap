class Map < ActiveRecord::Base
  attr_accessible :name, :slug, :cover_attributes, :plat_attributes, :description_attributes, :province_id
  
  has_many  :scenics,     :dependent => :destroy 
  has_many  :places,      :dependent => :destroy
  has_many  :recommend,   :dependent => :destroy
  
  has_one   :cover,       :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.cover }
  has_one   :plat,        :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.plat }
  has_many  :slides,      :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.slide }
  has_one   :description, :as => :textable,  :class_name => 'Text'
  
  belongs_to :province, :counter_cache => true

  # NestedAttributes
  accepts_nested_attributes_for :cover, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :plat, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :description, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true
  
   # Scopes
  scope :created_desc, order("created_at DESC")

  # Validates
  validates :name, :presence => true
  
end
