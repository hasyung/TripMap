class Recommend < ActiveRecord::Base

  # White list
  attr_accessible :map, :map_id, :name, :is_free, :category_cd, :menu_type,
                  :recommend_slug_attributes, :recommend_slug_icon_attributes,
                  :recommend_cover_attributes, :recommend_video_attributes

  # Associations
  with_options :as => :videoable, :class_name => "Video", :dependent => :destroy do |assoc|
    assoc.has_one :recommend_video,     :conditions => { :video_type => Video.recommend_video }
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do |assoc|
    assoc.has_one :recommend_slug_icon, :conditions => { :image_type => Image.recommend_slug_icon }
    assoc.has_one :recommend_cover,     :conditions => { :image_type => Image.recommend_cover }
  end

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_one :recommend_slug,      :conditions => { :keyword_type => Keyword.recommend_slug }
  end

  has_many :recommend_records, :dependent => :destroy

  belongs_to :map, :counter_cache => true

  # Enumeration, simple_enum plugin.
  as_enum :category, { one: 1, two: 2, three: 3 }

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }, :uniqueness => true
    column.validates :map_id
    column.validates :category_cd
  end

  # NestedAttributes
  accepts_nested_attributes_for :recommend_cover,       reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :recommend_slug_icon,   reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :recommend_video,       reject_if: lambda { |v| (v[:cover].blank? && v[:id].blank?) }, allow_destroy: true
  accepts_nested_attributes_for :recommend_slug,        allow_destroy: true

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end