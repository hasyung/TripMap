class InfoList < ActiveRecord::Base
  include ActiveModel::Validations

  attr_accessor :slug
  # White list
  attr_accessible :map_id, :name, :order, :is_free,
                  :infolist_slug_icon_attributes, :slug

  # Associations
  belongs_to :map, :counter_cache => true

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do |assoc|
    assoc.has_one :infolist_slug_icon, :conditions => { :image_type => Image.infolist_slug_icon }
  end

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do |assoc|
    assoc.has_many :info_list_slugs,     :conditions => { :keyword_type => Keyword.info_list_slugs }
  end

  has_many :infos, :dependent => :destroy

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, uniqueness: true, length: { within: 1..20 }
  end

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :infolist_slug_icon, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end