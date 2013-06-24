class FirstKnownListItem < ActiveRecord::Base

  # White list
  attr_accessible :first_known_list_id, :title, :description, :order,
                  :first_known_list_item_icon_attributes

  # Associations
  belongs_to :first_known_list

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one :first_known_list_item_icon,  :conditions => { :image_type => Image.first_known_list_item_icon }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :first_known_list_id
    column.validates :title, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :description
  end

  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :first_known_list_item_icon,  reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :order_asc,    order("`order` ASC")

end