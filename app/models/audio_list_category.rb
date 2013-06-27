class AudioListCategory < ActiveRecord::Base

  # White list
  attr_accessible :map_id, :name, :is_free, :menu_type,
                  :audio_list_category_slug_attributes, :audio_list_category_slug_cover_attributes

  # Associations
  belongs_to :map

  has_many :audio_lists, :dependent => :destroy

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_one :audio_list_category_slug,        :conditions => { :keyword_type => Keyword.audio_list_category_slug }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :audio_list_category_slug_cover, :conditions => { :image_type => Image.audio_list_category_slug_cover }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :audio_list_category_slug_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :audio_list_category_slug,                                                  :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

end