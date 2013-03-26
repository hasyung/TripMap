class RecommendDetailed < ActiveRecord::Base
  attr_accessible :name, :order, :recommend_record_id

  belongs_to :recommend_record, :counter_cache => true
  
  has_many :videos, :as => :videoable,  :dependent => :destroy
  has_many :audios, :as => :audioable,  :dependent => :destroy
  has_many :images, :as => :imageable,  :dependent => :destroy
  has_many :texts,  :as => :textable,   :dependent => :destroy, class_name: 'Letter'
  
  has_many :image_lists,  :dependent => :destroy

  validates :name, :length => { :within => 1..15,    :message => I18n.t("errors.type.name") }, :uniqueness => true, :presence => true
  
  validates_numericality_of :order, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999, :if => :order?

  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")
end
