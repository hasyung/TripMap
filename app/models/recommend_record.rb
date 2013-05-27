class RecommendRecord < ActiveRecord::Base
  # White list
  attr_accessible :recommend, :recommend_id, :name, :order, 
                  :recommend_record_cover_attributes, :recommend_record_description_attributes

  # Associations
  has_one :recommend_record_cover, :as => :imageable, :class_name => "Image",
          :conditions => { :image_type => Image.recommend_record_cover },
          :dependent => :destroy

  has_one :recommend_record_description, :as => :textable, :class_name => "Letter",
          :conditions => { :text_type => Letter.recommend_record_description },
          :dependent => :destroy 

  has_many :recommend_detaileds, :dependent => :destroy

  validate :order_increment
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }
    column.validates :order, uniqueness: { scope: [:recommend_id, :order] }, 
                             numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  end

  belongs_to :recommend, :counter_cache => true

  accepts_nested_attributes_for :recommend_record_cover,          reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :recommend_record_description, allow_destroy: true

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