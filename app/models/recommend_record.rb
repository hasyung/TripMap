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
    assoc.has_one :recommend_record_cover,      :conditions => { :image_type => Image.recommend_record_cover }
  end

  has_many :recommend_detaileds, :dependent => :destroy

  # Validates
  validate :order_increment
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }
    column.validates :order, uniqueness: { scope: [:recommend_id, :order] }, 
                             numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  end

  # Nested attributes validates
  accepts_nested_attributes_for :recommend_record_cover,          reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :recommend_record_description, allow_destroy: true

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  private

  def order_increment
    if self.new_record? && self.order == 0 && !self.recommend_id.nil?
      self.order = RecommendRecord.where( recommend_id: self.recommend_id ).maximum(:order).to_i + 1
    elsif self.recommend_id.nil?
      self.order = 1
    end
  end

end