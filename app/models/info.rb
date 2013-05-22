class Info < ActiveRecord::Base
  include ActiveModel::Validations

  # White list
  attr_accessible :info_list_id, :name, :slug, :order, :is_free,
                  :letter_attributes, :info_slug_attributes

  has_one :letter,  :as => :textable,   :dependent => :destroy

  belongs_to :info_list, :counter_cache => true
  has_one :info_slug, :as => :keywordable, :class_name => 'Keyword', 
          :conditions => { :keyword_type => Keyword.info_slug },
          :dependent => :destroy

  # NestedAttributes
  accepts_nested_attributes_for :letter, reject_if: lambda { |pd| pd[:body].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :info_slug, allow_destroy: true

  # Validates
  with_options :presence=> true do |column|
    column.validates :info_list_id
    column.validates :name, uniqueness: true, length: { within: 1..20 }
  end

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end