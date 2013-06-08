class MinorityFeel < ActiveRecord::Base
  # White list
  attr_accessible :name, :minority_id, :minority, :order,
                  :minority_feel_icon_attributes, :minority_feel_description_attributes

  # Associations
  belongs_to :minority

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one  :minority_feel_icon,               :conditions => { :image_type => Image.minority_feel_icon }
    assoc.has_many :minority_feel_slides,           :conditions => { :image_type => Image.minority_feel_slides  }
  end
  
  with_options :as => :textable, :class_name => "Letter", :dependent => :destroy do |assoc|
    assoc.has_one :minority_feel_description,       :conditions => { :text_type => Letter.minority_feel_description }
  end

  # Validates
  validate :order_increment
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }
    column.validates :minority_id
    column.validates :order, uniqueness: { scope: [:minority_id, :order] }, 
                             numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  end

  # Nested attributes validates
  accepts_nested_attributes_for :minority_feel_icon_attributes,              reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :minority_feel_description_attributes,       allow_destroy: true
 
  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")
  
  def order_increment
    if self.new_record? && self.order == 0 && !self.minority_id.nil?
      self.order = MinorityFeel.where( minority_id: self.minority_id ).maximum(:order).to_i + 1
    elsif self.minority_id.nil?
      self.order = 1
    end
  end
end
