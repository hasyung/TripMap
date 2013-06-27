class AudioListItem < ActiveRecord::Base

  # White list
  attr_accessible :audio_list_id, :title, :abstract, :order,
                  :audio_list_item_icon_attributes, :audio_list_item_audio_attributes, :audio_list_item_desc_attributes,
                  :audio_list_item_audio_cover_attributes

  # Associations
  belongs_to :audio_list

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one :audio_list_item_icon,        :conditions => { :image_type => Image.audio_list_item_icon }
    assoc.has_one :audio_list_item_audio_cover, :conditions => { :image_type => Image.audio_list_item_audio_cover }
  end

  with_options :as => :audioable, :class_name => 'Audio', :dependent => :destroy do|assoc|
    assoc.has_one :audio_list_item_audio, :conditions => { :audio_type => Audio.audio_list_item_audio }
  end

  with_options :as => :textable, :class_name => 'Letter', :dependent => :destroy do|assoc|
    assoc.has_one :audio_list_item_desc,  :conditions => { :text_type => Letter.audio_list_item_desc }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :audio_list_id
    column.validates :title, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :abstract
  end

  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :audio_list_item_icon,        reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :audio_list_item_audio_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :audio_list_item_audio,                                            :allow_destroy => true
  accepts_nested_attributes_for :audio_list_item_desc,                                             :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :order_asc,    order("`order` ASC")

end