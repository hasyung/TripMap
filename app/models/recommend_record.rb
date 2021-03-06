class RecommendRecord < ActiveRecord::Base

  # White list
  attr_accessible :recommend, :recommend_id, :name, :order, 
                  :recommend_record_cover_attributes, :recommend_record_description_attributes

  # Associations
  belongs_to :recommend, :counter_cache => true

  with_options :as => :textable, :class_name => 'Letter', :dependent => :destroy do|assoc|
    assoc.has_one :recommend_record_description, :conditions => { :text_type => Letter.recommend_record_description }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do|assoc|
    assoc.has_one :recommend_record_cover,       :conditions => { :image_type => Image.recommend_record_cover }
  end

  has_many :recommend_detaileds, :dependent => :destroy

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }
    column.validates :order, uniqueness: { scope: [:recommend_id, :order] }, 
                             numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  end
  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :recommend_record_cover,       reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :recommend_record_description,                                            :allow_destroy => true

  # Scopes
  scope :order_asc,    order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

end