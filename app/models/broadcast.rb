class Broadcast < ActiveRecord::Base

  attr_accessor :slug
  # White list
  attr_accessible :map_id, :name, :is_free, :menu_type, :slug,
                  :broadcast_slug_attributes, :broadcast_slug_cover_attributes

  # Associations
  belongs_to :map

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_many :broadcast_slugs,        :conditions => { :keyword_type => Keyword.broadcast_slugs }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :broadcast_slug_cover, :conditions => { :image_type => Image.broadcast_slug_cover }
  end

  has_many :children_broadcasts, :dependent => :destroy

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :broadcast_slug_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

end