class RecommendRecord < ActiveRecord::Base

  # White list
  attr_accessible :recommend, :recommend_id, :name, :order
  
  # Associations
  has_one :recommend_record_cover, :as => :imageable, :class_name => "Image", :conditions => { :image_type => Image.recommend_record_cover }, :dependent => :destroy
          
  has_one :recommend_record_description, :as => :textable, :class_name => "Text", :conditions => { :text_type => Text.recommend_record_description }, :dependent => :destroy 
  
  has_many :videos, :as => :videoable,  :dependent => :destroy
  has_many :audios, :as => :audioable,  :dependent => :destroy
  has_many :images, :as => :imageable,  :dependent => :destroy
  has_many :texts,  :as => :textable,   :dependent => :destroy
  
  has_many :image_lists
  
  belongs_to :recommend, :counter_cache => true
end
