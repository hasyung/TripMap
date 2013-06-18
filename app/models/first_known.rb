class FirstKnown < ActiveRecord::Base

  # White list
  attr_accessible :map_id, :name,
                  :first_known_slug_attributes, :first_known_slug_cover_attributes

  # Associations
  belongs_to :map

  has_many :first_known_lists, :dependent => :destroy

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_one :first_known_slug,        :conditions => { :keyword_type => Keyword.first_known_slug }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :first_known_slug_cover, :conditions => { :image_type => Image.first_known_slug_cover }
    assoc.has_many :first_known_slides,     :conditions => { :image_type => Image.first_known_slides }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :first_known_slug_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :first_known_slug,                                                  :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

end