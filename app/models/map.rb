class Map < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many  :scenics,     :dependent => :destroy 
  has_many  :places,      :dependent => :destroy
  has_many  :recommend,   :dependent => :destroy
  
  has_one   :cover,       :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.cover }
  has_one   :plat,        :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.plat }
  has_many  :slides,      :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.slide }
  has_one   :description, :as => :textable, :class_name => 'Text'
  
  belongs_to :province, :counter_cache => true
end
