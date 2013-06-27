class Minority < ActiveRecord::Base

  attr_accessor :slug
  # White list
  attr_accessible :name, :is_free, :menu_type, :minorityable_id, :minorityable_type, :order, :slug,
                  :minority_icon_attributes, :minority_slug_icon_attributes,
                  :minority_description_attributes, :minority_video_attributes,
                  :minority_slides_cover_attributes

  # Associations
  belongs_to :minorityable,    :polymorphic => true

  has_many   :minority_feels,  :dependent => :destroy
  has_many   :minority_slides, :dependent => :destroy

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one  :minority_icon,         :conditions => { :image_type => Image.minority_icon }
    assoc.has_one  :minority_slug_icon,    :conditions => { :image_type => Image.minority_slug_icon }
    assoc.has_one  :minority_slides_cover, :conditions => { :image_type => Image.minority_slides_cover }
  end

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do|assoc|
    assoc.has_many :minority_slugs,        :conditions => { :keyword_type => Keyword.minority_slugs }
  end

  with_options :dependent => :destroy do |assoc|
    assoc.has_one :minority_video, :as => :videoable, :class_name => "Video", :conditions => { :video_type => Video.minority_video }
  end

  with_options :as => :textable, :class_name => "Letter", :dependent => :destroy do |assoc|
    assoc.has_one :minority_description, :conditions => { :text_type => Letter.minority_description }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }, :uniqueness => true
    column.validates :minorityable_id
    column.validates :order, uniqueness: { scope: [:minorityable_id, :minorityable_type, :order] },
                             numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  end
  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :minority_icon,        reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :minority_slug_icon,   reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :minority_description,                                            :allow_destroy => true 
  accepts_nested_attributes_for :minority_video,       reject_if: ->(attr){ attr[:file].blank? && attr[:id].blank? }, :allow_destroy => true

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

end