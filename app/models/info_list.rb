class InfoList < ActiveRecord::Base
  include ActiveModel::Validations

  # White list
  attr_accessible :map_id, :name, :slug, :order, :is_free,
                  :infolist_slug_icon_attributes

  # Associations
  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do |assoc|
    assoc.has_one :infolist_slug_icon,         :conditions => { :image_type => Image.infolist_slug_icon }
  end

  has_many :infos, :dependent => :destroy

  belongs_to :map, :counter_cache => true

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, uniqueness: true, length: { within: 1..20 }
    column.validates :slug, uniqueness: true,
                            length: { within: 1..20 ,   message: I18n.t("errors.type.name") },
                            format: { with: /^[a-z]+$/, message: I18n.t("errors.type.slug") }
  end

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # NestedAttributes
  accepts_nested_attributes_for :infolist_slug_icon,              reject_if: lambda { |i| i[:file].blank? }, allow_destroy: true

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end