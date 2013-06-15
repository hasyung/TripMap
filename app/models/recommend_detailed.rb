class RecommendDetailed < ActiveRecord::Base

  # White list
  attr_accessible :name, :order, :recommend_record_id, :recommend_detailed_cover_attributes

  # Associations
  belongs_to :recommend_record, :counter_cache => true

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do|assoc|
    assoc.has_one  :recommend_detailed_cover,   :conditions => { :image_type => Image.recommend_detailed_cover   }
    assoc.has_many :detailed_images,  :conditions => { :image_type => Image.detailed_images  }
  end

  with_options :as => :textable, :class_name => 'Letter', :dependent => :destroy do|assoc|
    assoc.has_many :detailed_texts,  :conditions => { :text_type => Letter.detailed_text }
    assoc.has_many :detailed_infos,  :conditions => { :text_type => Letter.detailed_info }
  end

  has_many :videos, :as => :videoable,  :dependent => :destroy
  has_many :audios, :as => :audioable,  :dependent => :destroy
  has_many :image_lists,                :dependent => :destroy

  # Validates
  validate :order_increment

  validates :name, :length => { :within => 1..15 }, :presence => true
  validates :order, uniqueness: { scope: [:recommend_record_id, :order] },
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }

  # Nested attributes validates
  accepts_nested_attributes_for :recommend_detailed_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  private

  def order_increment
    if self.new_record? && self.order == 0 && !self.recommend_record_id.nil?
      self.order = RecommendDetailed.where( recommend_record_id: self.recommend_record_id ).maximum(:order).to_i + 1
    elsif self.recommend_record_id.nil?       
      self.order = 1
    end
  end

end