class Map < ActiveRecord::Base
  
  attr_accessible :province, :province_id, :name, :slug

  # Associations
  with_options :dependent => :destroy do |assoc|
     assoc.has_many :scenics
     assoc.has_many :places
     assoc.has_many :recommend
  end
  
  with_options :as => :imageable, :class_name => 'Image' do |assoc|
     assoc.has_one  :map_cover,   :conditions => { :image_type => Image.map_cover }
     assoc.has_one  :map_plat,    :conditions => { :image_type => Image.map_plat  }
     assoc.has_many :map_slides
  end

  has_one :map_description, :as => :textable, :class_name => 'Text', :conditions => { :text_type => Text.map_description }
  
  belongs_to :province, :counter_cache => true
  
  # Validates
  validates :name, :length => { :within => 0..15 }, :presence => true
  #validates :slug, :format => { :with => /([a-z]|[A-Z])+/ }, :if => :slug_required?
  
end
