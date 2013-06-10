class Broadcast < ActiveRecord::Base

  # White list
  attr_accessible :map_id, :name,
                  :broadcast_slug_attributes, :broadcast_slug_cover_attributes

  # Associations
  belongs_to :map

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_one :broadcast_slug,          :conditions => { :keyword_type => Keyword.broadcast_slug }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :broadcast_slug_cover,   :conditions => { :image_type => Image.broadcast_slug_cover }
  end

  has_many :children_broadcasts, :dependent => :destroy

   # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :broadcast_slug_cover, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :broadcast_slug,                                                      :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

end