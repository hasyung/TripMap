class ChildrenBroadcast < ActiveRecord::Base

  # White list
  attr_accessible :broadcast_id, :name, :order,
                  :children_broadcast_cover_attributes, :children_broadcast_audio_attributes,
                  :children_broadcast_desc_attributes,  :children_broadcast_audio_cover_attributes

  # Associations
  belongs_to :broadcast

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do|assoc|
    assoc.has_one  :children_broadcast_cover,       :conditions => { :image_type => Image.children_broadcast_cover }
    assoc.has_one  :children_broadcast_audio_cover, :conditions => { :image_type => Image.children_broadcast_audio_cover }
  end

  with_options :as => :audioable, :class_name => 'Audio', :dependent => :destroy do|assoc|
    assoc.has_one :children_broadcast_audio,  :conditions => { :audio_type => Audio.children_broadcast_audio }
  end

  with_options :as => :textable, :class_name => 'Letter', :dependent => :destroy do|assoc|
    assoc.has_one :children_broadcast_desc,   :conditions => { :text_type => Letter.children_broadcast_desc }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :broadcast_id
  end

  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :children_broadcast_cover,       reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :children_broadcast_audio_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :children_broadcast_audio,                                            :allow_destroy => true
  accepts_nested_attributes_for :children_broadcast_desc,                                             :allow_destroy => true

  # Scopes
  scope :order_asc,    order("`order` ASC")
  scope :created_desc, order("created_at DESC")

end