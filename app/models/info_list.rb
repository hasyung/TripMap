class InfoList < ActiveRecord::Base
  include ActiveModel::Validations

  # White list
  attr_accessible :map_id, :name, :info_list_slug_attributes, :order, :is_free

  # Associations
  has_many :infos, :dependent => :destroy

  belongs_to :map, :counter_cache => true
  has_one :info_list_slug, :as => :keywordable, :class_name => 'Keyword', 
          :conditions => { :keyword_type => Keyword.info_list_slug },
          :dependent => :destroy

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, uniqueness: true, length: { within: 1..20 }
  end

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  accepts_nested_attributes_for :info_list_slug, :allow_destroy => true

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end