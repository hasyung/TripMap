class FirstKnownList < ActiveRecord::Base

  # Disable type
  self.inheritance_column = nil

  # White list
  attr_accessible :first_known_id, :title_cn, :title_en, :url, :abstract, :order,
                  :first_known_list_icon_attributes

  # Associations
  belongs_to :first_known

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :first_known_list_icon, :conditions => { :image_type => Image.first_known_list_icon }
  end

  has_many :first_known_list_items, :dependent => :destroy

  # Validates
  with_options :presence => true do |column|
    column.validates :first_known_id
    column.validates :title_cn, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :title_en, :length => { :within => 1..20, :message => I18n.t("errors.type.name") },
                     :format => { :with => /^[A-Z|a-z]+$/,     :message => I18n.t("errors.first_known_list.title_en") }, :uniqueness => true
  end

  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :first_known_list_icon, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :order_asc,    order("`order` ASC")

end