class Special < ActiveRecord::Base
  # White list
  attr_accessible :name, :is_free, :menu_type,
                  :special_icon_attributes, :special_slug_icon_attributes, :special_slug_attributes

  # Associations
  has_many :minorities, :dependent => :destroy

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one  :special_icon,               :conditions => { :image_type => Image.special_icon }
    assoc.has_one  :special_slug_icon,          :conditions => { :image_type => Image.special_slug_icon }
  end

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do|assoc|
    assoc.has_one :special_slug,                :conditions => { :keyword_type => Keyword.special_slug }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :special_icon,              reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :special_slug_icon,         reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :special_slug,              allow_destroy: true

  # Scopes
  scope :created_desc, order("`created_at` DESC")
end
