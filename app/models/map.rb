class Map < ActiveRecord::Base
   attr_accessible :province, :province_id, :name, :slug

  # Associations
  with_options :dependent => :destroy do |assoc|
    assoc.has_many :scenics
    assoc.has_many :places
    assoc.has_many :recommends
  end
  
  with_options :as => :imageable, :class_name => 'Image' do |assoc|
    assoc.has_one  :map_cover,   :conditions => { :image_type => Image.map_cover }
    assoc.has_one  :map_plat,    :conditions => { :image_type => Image.map_plat  }
    assoc.has_many :map_slides
  end

  has_one :map_description, :as => :textable, :class_name => 'Text', :conditions => { :text_type => Text.map_description }
  
  belongs_to :province, :counter_cache => true

  # NestedAttributes
  accepts_nested_attributes_for :cover, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :plat, :reject_if => lambda { |a| a[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :description, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true
  
   # Scopes
  scope :created_desc, order("created_at DESC")

  # Validates
  validates :name, :length => { :within => 0..15 }, :presence => true
  #validates :slug, :format => { :with => /([a-z]|[A-Z])+/ }, :if => :slug_required?
  
end
