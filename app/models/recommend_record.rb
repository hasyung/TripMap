class RecommendRecord < ActiveRecord::Base

  attr_accessible :name, :order
  
  # Associations
  has_one :cover, :as => :imageable
  has_one :description, :as => :textable
  
  has_many :videos, :as => :videoable
  has_many :audios, :as => :audioable
  has_many :images, :as => :imageable
  has_many :texts,  :as => :textable
  has_many :image_lists
  
  belongs_to :recommend, :counter_cache => true
end
