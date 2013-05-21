class Merchant < ActiveRecord::Base

  attr_accessor :city
  # White list
  attr_accessible :name, :title, :conuty, :county_id, :address, :phone, :description, :tag, :city, :merchant_slug_attributes

  belongs_to :county, :counter_cache => true
  has_one :merchant_slug, :as => :keywordable, :class_name => 'Keyword', 
          :conditions => { :keyword_type => Keyword.merchant_slug },
          :dependent => :destroy

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_many :merchant_slides,  :conditions => { :image_type => Image.merchant_slides  }
  end

  # Validates
  validates :name, :length => { :within => 2..50 }, :presence => true
  validates :title, :length => { :within => 2..20 }, :presence => true
  validates :address, :length => { :within => 2..50 }, :presence => true
  validates :phone, :length => { :within => 7..11 }, :format => { :with => /^[0-9]+$/, :message => I18n.t("errors.type.phone") }, :presence => true
  validates :county_id, :presence => true
  validates :description, :length => { :within => 0..2000 }
  validates :tag, :length => { :within => 0..50 }

  accepts_nested_attributes_for :merchant_slug, allow_destroy: true

  scope :created_desc, order("`created_at` DESC")
end
