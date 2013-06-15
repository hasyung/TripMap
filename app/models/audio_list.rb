class AudioList < ActiveRecord::Base

  # White list
  attr_accessible :audio_list_category_id, :name, :abstract, :order,
                  :audio_list_icon_attributes

  # Associations
  belongs_to :audio_list_category

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :audio_list_icon, :conditions => { :image_type => Image.audio_list_icon }
  end

  has_many :audio_list_items, :dependent => :destroy

  # Validates
  with_options :presence => true do |column|
    column.validates :audio_list_category_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :abstract
  end

  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :audio_list_icon, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :order_asc,    order("`order` ASC")

end