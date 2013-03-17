class Recommend < ActiveRecord::Base
  
  # White list
  attr_accessible :map, :map_id, :name, :slug, :recommend_cover_attributes, :recommend_video_attributes

  # Associations
  has_one :recommend_video, :as => :videoable, :class_name => "Video",
          :conditions => { :video_type => Video.recommend_video },
          :dependent => :destroy
          
  has_one :recommend_cover, :as => :imageable, :class_name => "Image",
          :conditions => { :image_type => Image.recommend_cover },
          :dependent => :destroy

  has_many :recommend_records, :dependent => :destroy

  belongs_to :map, :counter_cache => true
  
  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15,    :message => I18n.t("errors.type.name") }
    column.validates :slug, :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }
    column.validates :map_id
  end

  # NestedAttributes
  accepts_nested_attributes_for :recommend_cover,       reject_if: lambda { |c| c[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :recommend_video,       reject_if: lambda { |v| v[:file].blank? }, allow_destroy: true


end
