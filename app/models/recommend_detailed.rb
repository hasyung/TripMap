class RecommendDetailed < ActiveRecord::Base
  attr_accessible :name, :order, :recommend_record_id

  belongs_to :recommend_records, :counter_cache => true
  
  has_many :videos, :as => :videoable,  :dependent => :destroy
  has_many :audios, :as => :audioable,  :dependent => :destroy
  has_many :images, :as => :imageable,  :dependent => :destroy
  has_many :texts,  :as => :textable,   :dependent => :destroy, class_name: 'Letter'
  
  has_many :image_lists
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")
end
