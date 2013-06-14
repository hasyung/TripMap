class ChildrenBroadcast < ActiveRecord::Base

  # White list
  attr_accessible :broadcast_id, :name, :cover, :audio, :duration, :size, :description, :order,
                  :broadcast_cover_attributes, :broadcast_audio_attributes, :broadcast_desc_attributes

  # Associations
  belongs_to :broadcast

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do|assoc|
    assoc.has_one  :broadcast_cover,   :conditions => { :image_type => Image.broadcast_cover }
  end

  with_options :as => :audioable, :class_name => 'Audio', :dependent => :destroy do|assoc|
    assoc.has_one :broadcast_audio,    :conditions => { :audio_type => Audio.broadcast_audio }
  end

  with_options :as => :textable, :class_name => 'Letter', :dependent => :destroy do|assoc|
    assoc.has_one :broadcast_desc,     :conditions => { :text_type => Letter.broadcast_desc }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :broadcast_id
  end

  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :broadcast_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :broadcast_audio,                                            :allow_destroy => true
  accepts_nested_attributes_for :broadcast_desc,                                             :allow_destroy => true

  # Scopes
  scope :order_asc,    order("`order` ASC")
  scope :created_desc, order("created_at DESC")

end