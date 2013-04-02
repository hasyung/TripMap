class RecommendDetailed < ActiveRecord::Base
  attr_accessible :name, :order, :recommend_record_id, :recommend_detailed_cover_attributes

  belongs_to :recommend_record, :counter_cache => true
  
  # Associations
  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :recommend_detailed_cover,   :conditions => { :image_type => Image.recommend_detailed_cover   }
    assoc.has_many :detailed_images,  :conditions => { :image_type => Image.detailed_images  }
  end

  has_many :videos, :as => :videoable,  :dependent => :destroy
  has_many :audios, :as => :audioable,  :dependent => :destroy
  has_many :texts,  :as => :textable,   :dependent => :destroy, class_name: 'Letter'
  
  has_many :image_lists,  :dependent => :destroy

  accepts_nested_attributes_for :recommend_detailed_cover,          reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true

  validates :name, :length => { :within => 1..15,    :message => I18n.t("errors.type.name") }, :uniqueness => true, :presence => true
  
  validates :order, uniqueness: { scope: [:recommend_record_id, :order] }, 
                    numericality: { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 999 }
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")
end
