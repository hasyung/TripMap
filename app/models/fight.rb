class Fight < ActiveRecord::Base
  # White list
  attr_accessible :name, :county_id, :county,
                  :fight_icon_attributes, :fight_slug_icon_attributes, :fight_slug_attributes, :fight_video_attributes

  # Associations
  belongs_to :county
  with_options :as => :minorityable, :class_name => "Minority", :dependent => :destroy do|assoc|
    assoc.has_many  :minorities
  end

  with_options :as => :imageable, :class_name => "Image", :dependent => :destroy do|assoc|
    assoc.has_one  :fight_icon,      :conditions => { :image_type => Image.fight_icon }
    assoc.has_one  :fight_slug_icon, :conditions => { :image_type => Image.fight_slug_icon }
  end

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do|assoc|
    assoc.has_one :fight_slug,       :conditions => { :keyword_type => Keyword.fight_slug }
  end

  with_options :as => :videoable, :class_name => "Video", :dependent => :destroy do |assoc|
    assoc.has_one :fight_video,     :conditions => { :video_type => Video.fight_video }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..20 }, :uniqueness => true
    column.validates :county_id
  end

  # Nested attributes validates
  accepts_nested_attributes_for :fight_icon,      reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :fight_slug_icon, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :fight_slug,                                                 :allow_destroy => true
  accepts_nested_attributes_for :fight_video,     reject_if: ->(attr){ (attr[:cover].blank? && attr[:id].blank?) }, :allow_destroy => true

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end