class ImageList < ActiveRecord::Base

  # White list
  attr_accessible :name, :order,
                  :image_list_images_cover_attributes

  # Associations
  belongs_to :recommend_detailed

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :image_list_images_cover, :conditions => { :image_type => Image.image_list_cover }
  end

  has_many :images, :as => :imageable, :dependent => :destroy

  # Validates
  validates :name, length: { within: 1..20 }, presence: true

  validates :order, uniqueness: { scope: [:recommend_detailed_id, :order] },
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :image_list_images_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

end