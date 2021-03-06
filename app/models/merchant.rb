class Merchant < ActiveRecord::Base

  attr_accessor :city, :slug

  # White list
  attr_accessible :name, :title, :conuty, :county_id, :address, :phone, :shop_hour, :expence, :special, :description, :tag, :type_cd, :city,
                  :slug, :merchant_image_attributes, :merchant_horizontal_image_attributes, :merchant_video_attributes,
                  :privilege

  #SimpleEnum
  as_enum :type, { :meishi => 0, :gouwu => 1, :yule => 2, :zhusu => 4 }

  # Associations
  belongs_to :county, :counter_cache => true

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do|assoc|
    assoc.has_many  :merchant_slugs,    :conditions => { :keyword_type => Keyword.merchant_slugs }
  end

  with_options :as => :videoable, :class_name => "Video", :dependent => :destroy do |assoc|
    assoc.has_one :merchant_video,     :conditions => { :video_type => Video.merchant_video }
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_many :merchant_slides,  :conditions => { :image_type => Image.merchant_slides }
    assoc.has_one  :merchant_image,   :conditions => { :image_type => Image.merchant_image }
    assoc.has_one  :merchant_horizontal_image,   :conditions => { :image_type => Image.merchant_horizontal_image }
  end

  # Validates
  with_options :presence=> true do |column|
    column.validates :name,        :length => { :within => 2..50 }
    column.validates :title,       :length => { :within => 2..50 }
    column.validates :address,     :length => { :within => 2..50 }
    column.validates :phone,       :length => { :within => 7..12 }, :format => { :with => /^[0-9]+$/, :message => I18n.t("errors.type.phone") }
    column.validates :county_id
  end
  validates :shop_hour,   :length => { :within => 0..20 }
  validates :expence,     :length => { :within => 0..20 }
  validates :description, :length => { :within => 0..2000 }
  validates :special,     :length => { :within => 0..200 }
  validates :tag,         :length => { :within => 0..50 }
  validates :privilege,   :length => { :within => 0..300 }

  # Nested attributes validates
  accepts_nested_attributes_for :merchant_image,            reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :merchant_horizontal_image, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :merchant_video,            reject_if: ->(attr){ (attr[:cover].blank? && attr[:id].blank?) }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end