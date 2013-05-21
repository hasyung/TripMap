class Recommend < ActiveRecord::Base

  # White list
  attr_accessible :map, :map_id, :name, :recommend_slug_attributes, :is_free, :category_cd, :menu_type,
                  :recommend_cover_attributes, :recommend_video_attributes

  # Associations
  has_one :recommend_video, :as => :videoable, :class_name => "Video",
          :conditions => { :video_type => Video.recommend_video },
          :dependent => :destroy

  has_one :recommend_cover, :as => :imageable, :class_name => "Image",
          :conditions => { :image_type => Image.recommend_cover },
          :dependent => :destroy
  has_one :recommend_slug, :as => :keywordable, :class_name => 'Keyword', 
          :conditions => { :keyword_type => Keyword.recommend_slug },
          :dependent => :destroy

  has_many :recommend_records, :dependent => :destroy

  belongs_to :map, :counter_cache => true

  # Enumeration, simple_enum plugin.
  as_enum :category, { one: 1, two: 2, three: 3 }

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20}, :uniqueness => true
    column.validates :map_id
    column.validates :category_cd
  end

  # NestedAttributes
  accepts_nested_attributes_for :recommend_cover,       reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :recommend_video,       reject_if: lambda { |v| (v[:cover].blank? && v[:id].blank?) }, allow_destroy: true
  accepts_nested_attributes_for :recommend_slug,       allow_destroy: true


  # Scopes
  scope :created_desc, order("`created_at` DESC")

end