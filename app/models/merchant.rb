class Merchant < ActiveRecord::Base

  attr_accessor :city

  # White list
  attr_accessible :name, :title, :conuty, :county_id, :address, :phone, :shop_hour, :expence, :special, :description, :tag, :type_cd, :city,
                  :merchant_slug_attributes, :merchant_image_attributes
  
  #SimpleEnum
  as_enum :type, {:meishi => 0, :gouwu => 1, :yule => 2, :zhusu => 4}
  
  # Associations
  belongs_to :county, :counter_cache => true

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do|assoc|
    assoc.has_one :merchant_slug, :conditions => { :keyword_type => Keyword.merchant_slug }
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_many :merchant_slides,  :conditions => { :image_type => Image.merchant_slides  }
    assoc.has_one  :merchant_image,   :conditions => { :image_type => Image.merchant_image  }
  end

  # Validates
  validates :name, :length => { :within => 2..50 }, :presence => true
  validates :title, :length => { :within => 2..20 }, :presence => true
  validates :address, :length => { :within => 2..50 }, :presence => true
  validates :shop_hour, :length => { :within => 0..20 }
  validates :expence, :length => { :within => 0..20 }
  validates :phone, :length => { :within => 7..11 }, :format => { :with => /^[0-9]+$/, :message => I18n.t("errors.type.phone") }, :presence => true
  validates :county_id, :presence => true
  validates :description, :length => { :within => 0..2000 }
  validates :special, :length => { :within => 0..200 }
  validates :tag, :length => { :within => 0..50 }

  # Nested attributes validates
  accepts_nested_attributes_for :merchant_slug, allow_destroy: true
  accepts_nested_attributes_for :merchant_image, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end